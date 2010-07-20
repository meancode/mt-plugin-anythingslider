# TemplateInstaller plugin for Movable Type
# http://mt-hacks.com/templateinstaller.html
# v1.01 - added Template Exporter links
# v1.02 - added two new template sets to package, no code changes
# v1.03 - removed duplicate 'instance' sub
# v1.1 - support for 4.1 style template set config.yaml files, and use in 4.1
#		- refactored to store subs in TemplateInstaller::App::CMS
# v1.11 - fix for case when installing directly from another plugin's settings
# v1.2 - now supports installation of template mappings, if specified in config.yaml
#
# This plugins builds off of the TemplateRefresh Plugin:
#   Author: Nick O'Neill and Brad Choate, Six Apart (http://www.sixapart.com)
#   Released under the Artistic License

package MT::Plugin::TemplateInstaller;

use strict;
use MT;
use base qw(MT::Plugin);
use vars qw($VERSION);
$VERSION = '1.2';

my $plugin = MT::Plugin::TemplateInstaller->new({
    name => 'Template Installer',
	id => 'templateinstaller',
    description => "Used to install complete or partial blog template sets.",
	doc_link => "http://mt-hacks.com/templateinstaller.html",
	plugin_link => "http://mt-hacks.com/templateinstaller.html",
	author_name => "Mark Carey",
	author_link => "http://mt-hacks.com/",
    version => $VERSION,
});
MT->add_plugin($plugin);

sub instance { $plugin }

sub init_registry {
	my $component = shift;
	my $reg = {
		'applications' => {
			'cms' => {
				'methods' => {
					'install_blog_templates' => '$TemplateInstaller::TemplateInstaller::App::CMS::install_blog_templates',
    			    'install_templates_dialog' => '$TemplateInstaller::TemplateInstaller::App::CMS::install_templates_dialog',
    			    'get_exporter' => '$TemplateInstaller::TemplateInstaller::App::CMS::get_exporter',
				},
                page_actions => {
                    list_templates => {
                        'template_installer' => {
                            label => 'Install Templates',
                            dialog  => 'install_templates_dialog',
                            permission => 'edit_templates',
                        },
                        'get_template_exporter' => {
                            label => 'Export Templates',
                            dialog  => 'get_exporter',
                            permission => 'edit_templates',
							condition => '$TemplateInstaller::TemplateInstaller::App::CMS::exporter_not_installed',
                        }
                    },
                },
                list_actions => {
                	template => {
                    	get_exporter_list_templates => {
                    		label => "Export Template(s)",
                        	dialog  => 'get_exporter',
							code => '$TemplateInstaller::TemplateInstaller::App::CMS::get_exporter',
                        	permissions => 'can_edit_templates',
							condition => '$TemplateInstaller::TemplateInstaller::App::CMS::exporter_not_installed',
                    	},
                	},
				},
			},
		},
	};
	$component->registry($reg);
}


1;