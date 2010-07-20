package TemplateInstaller::App::CMS;

use strict;

sub init_template_set {
	my $plugin = MT::Plugin::TemplateInstaller->instance;
	my ($set,$path) = @_;
	if (!$path) {
		$path = $plugin->path . '/template_sets/' . $set;
	}
	use YAML::Tiny;
	my $yaml = YAML::Tiny->new;
	$yaml = YAML::Tiny->read( $path . '/config.yaml' )
		or die "Error reading template set at $path Error: " . $YAML::Tiny::errstr;
	my $set_hash = $yaml->[0];
	$plugin->registry($set_hash);
}

sub template_sets {
	my $plugin = MT::Plugin::TemplateInstaller->instance;
	my $template_sets_path = $plugin->path . "/template_sets";
	my @template_sets;
    local *DH;
    if ( opendir DH, $template_sets_path ) {
       my @p = readdir DH;
	   foreach my $dir (@p) {
		    next if $dir =~ /^\./; # skip over dot files
		    my $fullname = "$template_sets_path/$dir"; # get full name
    		next unless -d $fullname;
			push @template_sets, $dir;
		}
	}
    closedir DH;
	return @template_sets;
}

my $loaded =0;

sub load_templates {
    my $app = shift;
	my $plugin = MT::Plugin::TemplateInstaller->instance;
	my $set = $app->param('set');
	my $path = $app->param('template_path');
	if (!$path) {
		$path = $plugin->path . "/template_sets/" . $set;
	}
	init_template_set($set,$path);
	my $templates = MT->registry('template_sets',$set,'templates');
	if ($templates) {
		$path = $path . "/templates";
	} else {
		$templates = MT->registry('template_sets',$set);
	}

    unless ($loaded) {
        require MT::Util;
        require MT;
        use File::Spec;

        local (*FIN, $/);
        $/ = undef;
        foreach my $tmpl_set (keys %$templates) {
            foreach my $tmpl_id (keys %{ $templates->{$tmpl_set} }) {
                my $tmpl = $templates->{$tmpl_set}{$tmpl_id};
                my $file = File::Spec->catfile($path, $tmpl_id . '.mtml');
                if ((-e $file) && (-r $file)) {
                    open FIN, "<$file"; my $data = <FIN>; close FIN;
                    $tmpl->{text} = $data;
                } else {
                    $tmpl->{text} = '';
                }
            }
        }
        $loaded = 1;
    }

	my $def_tmpl = $templates;
    my @tmpls;

    # copy structure, then run filter
    foreach my $tmpl_set (keys %$def_tmpl) {
        foreach my $tmpl_id (keys %{ $def_tmpl->{$tmpl_set} }) {
            next if $tmpl_id eq 'plugin';

            my $tmpl = $def_tmpl->{$tmpl_set}{$tmpl_id};
            my $type = $tmpl_set;
            $type = 'custom' if $tmpl_set eq 'module';
            $type = $tmpl_id if $tmpl_set eq 'system';
            my $name = $tmpl->{label};
            $name = $name->() if ref($name) eq 'CODE';
            $tmpl->{name} = $name;
            $tmpl->{type} = $type;
            $tmpl->{key} = $tmpl_id;
            $tmpl->{identifier} = $tmpl_id;
            push @tmpls, $tmpl;
        }
    }
    return \@tmpls;
}

sub install_blog_templates {
	my $plugin = MT::Plugin::TemplateInstaller->instance;
    my $app = MT->instance;
	my $set = $app->param('set');
	$set = format_name($set);

    my $t = time;

    my @id = $app->param('id');

	if (!$app->param('id')) {
		push @id, $app->param('blog_id');
	}

    require MT::Template;
    my $tmpl_list = load_templates($app) or return;

 #   my $dict = MT::Plugin::TemplateRefresh::default_dictionary();

    my @msg;
    require MT::Blog;
    require MT::Permission;
    require MT::Util;

    foreach my $blog_id (@id) {
        my $blog = MT::Blog->load($blog_id);
        next unless $blog;
        if ( !$app->{author}->is_superuser() ) {
            my $perms = MT::Permission->load(
                { blog_id => $blog_id, author_id => $app->{author}->id } );
            if (
                !$perms
                || (   !$perms->can_edit_templates()
                    && !$perms->can_administer_blog() )
              )
            {
                push @msg,
                  $app->translate(
"Insufficient permissions to modify templates for weblog '[_1]'",
                    $blog->name()
                  );
                next;
            }
        }

        push @msg,
          $app->translate( "Installing templates for weblog '[_1]'",
            $blog->name );
		my @arch_tmpl;
        foreach my $val (@$tmpl_list) {
            if ( !$val->{orig_name} ) {
                $val->{orig_name} = $val->{name};
                $val->{name}      = $app->translate( $val->{name} );
                $val->{text}      = $app->translate_templatized( $val->{text} );
            }
            my $orig_name = $val->{orig_name};

            my @ts = MT::Util::offset_time_list( $t, $blog_id );
            my $ts = sprintf "%04d-%02d-%02d %02d:%02d:%02d", $ts[5] + 1900,
              $ts[4] + 1, @ts[ 3, 2, 1, 0 ];

            my $terms = {};
            $terms->{blog_id} = $blog_id;
            if ( $val->{type} =~
                m/^(archive|individual|page|category|index|custom|widget)$/ )
            {
                $terms->{name} = $val->{name};
            }
            else {
                $terms->{type} = $val->{type};
            }

            # this should only return 1 template; we're searching
            # within a given blog for a specific type of template (for
            # "system" templates; or for a type + name, which should be
            # unique for that blog.
            my $tmpl = MT::Template->load($terms);
            if ($tmpl) {

                # check for default template text...
                # if it is a default template, then outright replace it
                my $text = $tmpl->text;
                $text =~ s/\s+//g;

                my $def_text = $val->{text};
                $def_text =~ s/\s+//g;

                # generate sha1 of $text
          #      my $digest = MT::Util::perl_sha1_digest_hex($text);
          #      if ( !$dict->{ $val->{type} }{$orig_name}{$digest} ) {
                if ($def_text ne $text) {
                    # if it has been customized, back it up to a new tmpl record
                    my $backup = $tmpl->clone;
                    delete $backup->{column_values}
                      ->{id};    # make sure we don't overwrite original
                    delete $backup->{changed_cols}->{id};
                    $backup->name(
                        $backup->name . ' (Backup from ' . $ts . ')' );
					if (MT->VERSION >= 4.1) {
                    	$backup->type('backup');
					} else {
	                    if ( $backup->type !~
    	                    m/^(archive|individual|page|category|index|custom|widget)$/ )
        	            {
            	            $backup->type('custom')
                	          ;      # system templates can't be created
                    	}
					}
                    $backup->outfile('');
                    $backup->linked_file( $tmpl->linked_file );
                    $backup->identifier(undef);
                    $backup->rebuild_me(0);
                    $backup->build_dynamic(0);
                    $backup->save;
                    push @msg,
                      $app->translate(
'Installing template <strong>[_3]</strong> with <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>',
                        $blog_id, $backup->id, $tmpl->name );
                }
                else {
                    push @msg,
                      $app->translate( "Installing template '[_1]'.",
                        $tmpl->name );
                }

                # we found that the previous template had not been
                # altered, so replace it with new default template...
                $tmpl->text( $val->{text} );
                $tmpl->identifier( $val->{identifier} );
                $tmpl->type( $val->{type} )
                  ; # fixes mismatch of types for cases like "archive" => "individual"
                $tmpl->linked_file('');
				$tmpl->build_dynamic( $val->{build_dynamic} );
                $tmpl->save;
            }
            else {

                # create this one...
                my $tmpl = new MT::Template;
                $tmpl->build_dynamic(0);
                $tmpl->set_values(
                    {
                        text       => $val->{text},
                        name       => $val->{name},
                        type       => $val->{type},
                        identifier => $val->{identifier},
                        outfile    => $val->{outfile},
                        rebuild_me => $val->{rebuild_me},
						build_dynamic => $val->{build_dynamic}
                    }
                );
                $tmpl->blog_id($blog_id);
                $tmpl->save
                  or return $app->error(
                        $app->translate("Error creating new template: ")
                      . $tmpl->errstr );
  			    if ($val->{mappings}) {
            		push @arch_tmpl, {
                		template => $tmpl,
                		mappings => $val->{mappings},
                		exists($val->{preferred}) ? (preferred => $val->{preferred}) : ()
            		};
        		}
                push @msg,
                  $app->translate( "Created template '[_1]'.", $tmpl->name );
            }
        }
	    if (@arch_tmpl) {
    	    require MT::TemplateMap;
        	for my $map_set (@arch_tmpl) {
	            my $tmpl = $map_set->{template};
    	        my $mappings = $map_set->{mappings};
        	    foreach my $map_key (keys %$mappings) {
            	    my $m = $mappings->{$map_key};
                	my $at = $m->{archive_type};
                	# my $preferred = $mappings->{$map_key}{preferred};
                	my $map = MT::TemplateMap->new;
                	$map->archive_type($at);
                	if ( exists $m->{preferred} ) {
                    	$map->is_preferred($m->{preferred});
                	}
                	else {
                    	$map->is_preferred(1);
                	}
                	$map->template_id($tmpl->id);
                	$map->file_template($m->{file_template}) if $m->{file_template};
                	$map->blog_id($tmpl->blog_id);
                	$map->save;
            	}
        	}
    	}

	    MT->run_callbacks(
    	    'post_install_templates',
        	$blog, 
        	$tmpl_list
    	);
    }

    my @msg_loop;
    push @msg_loop, { message => $_ } foreach @msg;

    $app->param('__mode', '');
    $app->mode('');
    $app->build_page( $plugin->load_tmpl('results.tmpl'),
        { message_loop => \@msg_loop, return_url => $app->return_uri, set_name => $set } );
}

sub install_templates_dialog {
    my $app     = MT->instance;
	my $plugin = MT::Plugin::TemplateInstaller->instance;
    my $blog_id = $app->param('blog_id')
      or return $app->error('blog_id is required.');
	my @sets = template_sets();
    my @sets_loop;
	my $exporter_not_installed = exporter_not_installed();
    push @sets_loop, { set => $_, set_name => format_name($_) } foreach @sets;
    $app->build_page($plugin->load_tmpl('install_templates.tmpl'), 
		{ template_loop => \@sets_loop, blog_id => $blog_id, exporter_not_installed => $exporter_not_installed } );
}

sub format_name {
	my ($set) = @_;
	$set =~ s!_! !gs;
	my @words = split( / /, $set );
	foreach (@words) { $_ = ucfirst }
	$set = join( ' ', @words );
	$set;
}

sub exporter_not_installed {
	my $exporter_not_installed;
	eval {
   		MT::Plugin::TemplateExporter->instance;
	};
	if ($@) {
		$exporter_not_installed = 1;
	}
	return $exporter_not_installed;
}

sub get_exporter {
    my $app = MT->instance;
	my $plugin = MT::Plugin::TemplateInstaller->instance;
    $app->build_page($plugin->load_tmpl('get_exporter.tmpl'),
		{ return_url => $app->return_uri } );
}

1;