# WARNING: this file is generated, do not edit
# generated on Fri Jun 14 16:22:25 2013
# 01: /usr/local/lib/perl5/site_perl/5.16.3/x86_64-linux-thread-multi/Apache/TestConfig.pm:961
# 02: /usr/local/lib/perl5/site_perl/5.16.3/x86_64-linux-thread-multi/Apache/TestConfig.pm:979
# 03: /usr/local/lib/perl5/site_perl/5.16.3/x86_64-linux-thread-multi/Apache/TestConfig.pm:1878
# 04: /usr/local/lib/perl5/site_perl/5.16.3/x86_64-linux-thread-multi/Apache/TestRun.pm:503
# 05: /usr/local/lib/perl5/site_perl/5.16.3/x86_64-linux-thread-multi/Apache/TestRun.pm:713
# 06: /usr/local/lib/perl5/site_perl/5.16.3/x86_64-linux-thread-multi/Apache/TestRun.pm:713
# 07: /home/mkandel/src/POC/apache_testing/ariba_tests/framework/bin/../lib/ariba/Test/Apache/TestServer.pm:30
# 08: /home/mkandel/src/POC/apache_testing/ariba_tests/framework/bin/../lib/ariba/Test/Apache.pm:34
# 09: /home/mkandel/src/POC/apache_testing/ariba_tests/framework/bin/test.pl:41

package apache_test_config;

sub new {
    bless( {
         "verbose" => undef,
         "hostport" => "localhost:8529",
         "postamble" => [
                          #0
                          "<IfModule mod_mime.c>\n    TypesConfig \"/opt/apache/conf/mime.types\"\n</IfModule>\n",
                          #1
                          "\n"
                        ],
         "mpm" => "prefork",
         "inc" => [],
         "APXS" => "/usr/sbin/apxs",
         "_apxs" => {
                      "LIBEXECDIR" => "/usr/lib64/httpd/modules",
                      "SYSCONFDIR" => "/etc/httpd/conf",
                      "TARGET" => "httpd",
                      "BINDIR" => "/usr/bin",
                      "PREFIX" => "/etc/httpd",
                      "SBINDIR" => "/usr/sbin"
                    },
         "save" => 1,
         "vhosts" => {},
         "httpd_basedir" => "/opt/apache",
         "server" => bless( {
                              "run" => bless( {
                                                "port" => 8888,
                                                "conf_opts" => {
                                                                 "authname" => "Ariba, Inc.",
                                                                 "verbose" => undef,
                                                                 "save" => 1,
                                                                 "httpd_conf" => "/opt/apache/conf/httpd.conf",
                                                                 "httpd" => "/opt/apache/bin/httpd"
                                                               },
                                                "test_config" => $VAR1,
                                                "tests" => [],
                                                "argv" => [],
                                                "opts" => {
                                                            "stop-httpd" => 1,
                                                            "breakpoint" => [],
                                                            "start-httpd" => 1,
                                                            "postamble" => [],
                                                            "preamble" => [],
                                                            "run-tests" => 1,
                                                            "req_args" => {},
                                                            "header" => {}
                                                          },
                                                "subtests" => [
                                                                #0
                                                                0
                                                              ],
                                                "server" => $VAR1->{"server"}
                                              }, 'ariba::Test::Apache::TestServer' ),
                              "port_counter" => 8529,
                              "mpm" => "prefork",
                              "version" => "Apache/2.4.4",
                              "rev" => 2,
                              "name" => "localhost:8529",
                              "config" => $VAR1
                            }, 'Apache::TestServer' ),
         "postamble_hooks" => [
                                #0
                                sub { "DUMMY" }
                              ],
         "inherit_config" => {
                               "ServerRoot" => "/opt/apache",
                               "ServerAdmin" => "you\@example.com",
                               "TypesConfig" => "conf/mime.types",
                               "DocumentRoot" => "/opt/apache/htdocs",
                               "LoadModule" => [
                                                 #0
                                                 [
                                                   #0
                                                   "access_compat_module",
                                                   #1
                                                   "modules/mod_access_compat.so"
                                                 ],
                                                 #1
                                                 [
                                                   #0
                                                   "auth_basic_module",
                                                   #1
                                                   "modules/mod_auth_basic.so"
                                                 ],
                                                 #2
                                                 [
                                                   #0
                                                   "socache_shmcb_module",
                                                   #1
                                                   "modules/mod_socache_shmcb.so"
                                                 ],
                                                 #3
                                                 [
                                                   #0
                                                   "socache_memcache_module",
                                                   #1
                                                   "modules/mod_socache_memcache.so"
                                                 ],
                                                 #4
                                                 [
                                                   #0
                                                   "reqtimeout_module",
                                                   #1
                                                   "modules/mod_reqtimeout.so"
                                                 ],
                                                 #5
                                                 [
                                                   #0
                                                   "filter_module",
                                                   #1
                                                   "modules/mod_filter.so"
                                                 ],
                                                 #6
                                                 [
                                                   #0
                                                   "mime_module",
                                                   #1
                                                   "modules/mod_mime.so"
                                                 ],
                                                 #7
                                                 [
                                                   #0
                                                   "log_config_module",
                                                   #1
                                                   "modules/mod_log_config.so"
                                                 ],
                                                 #8
                                                 [
                                                   #0
                                                   "env_module",
                                                   #1
                                                   "modules/mod_env.so"
                                                 ],
                                                 #9
                                                 [
                                                   #0
                                                   "headers_module",
                                                   #1
                                                   "modules/mod_headers.so"
                                                 ],
                                                 #10
                                                 [
                                                   #0
                                                   "setenvif_module",
                                                   #1
                                                   "modules/mod_setenvif.so"
                                                 ],
                                                 #11
                                                 [
                                                   #0
                                                   "version_module",
                                                   #1
                                                   "modules/mod_version.so"
                                                 ],
                                                 #12
                                                 [
                                                   #0
                                                   "proxy_module",
                                                   #1
                                                   "modules/mod_proxy.so"
                                                 ],
                                                 #13
                                                 [
                                                   #0
                                                   "proxy_http_module",
                                                   #1
                                                   "modules/mod_proxy_http.so"
                                                 ],
                                                 #14
                                                 [
                                                   #0
                                                   "proxy_balancer_module",
                                                   #1
                                                   "modules/mod_proxy_balancer.so"
                                                 ],
                                                 #15
                                                 [
                                                   #0
                                                   "slotmem_shm_module",
                                                   #1
                                                   "modules/mod_slotmem_shm.so"
                                                 ],
                                                 #16
                                                 [
                                                   #0
                                                   "lbmethod_byrequests_module",
                                                   #1
                                                   "modules/mod_lbmethod_byrequests.so"
                                                 ],
                                                 #17
                                                 [
                                                   #0
                                                   "lbmethod_bytraffic_module",
                                                   #1
                                                   "modules/mod_lbmethod_bytraffic.so"
                                                 ],
                                                 #18
                                                 [
                                                   #0
                                                   "lbmethod_bybusyness_module",
                                                   #1
                                                   "modules/mod_lbmethod_bybusyness.so"
                                                 ],
                                                 #19
                                                 [
                                                   #0
                                                   "lbmethod_heartbeat_module",
                                                   #1
                                                   "modules/mod_lbmethod_heartbeat.so"
                                                 ],
                                                 #20
                                                 [
                                                   #0
                                                   "unixd_module",
                                                   #1
                                                   "modules/mod_unixd.so"
                                                 ],
                                                 #21
                                                 [
                                                   #0
                                                   "status_module",
                                                   #1
                                                   "modules/mod_status.so"
                                                 ],
                                                 #22
                                                 [
                                                   #0
                                                   "autoindex_module",
                                                   #1
                                                   "modules/mod_autoindex.so"
                                                 ],
                                                 #23
                                                 [
                                                   #0
                                                   "info_module",
                                                   #1
                                                   "modules/mod_info.so"
                                                 ],
                                                 #24
                                                 [
                                                   #0
                                                   "dir_module",
                                                   #1
                                                   "modules/mod_dir.so"
                                                 ],
                                                 #25
                                                 [
                                                   #0
                                                   "alias_module",
                                                   #1
                                                   "modules/mod_alias.so"
                                                 ]
                                               ],
                               "LoadFile" => []
                             },
         "cmodules_disabled" => {},
         "preamble_hooks" => [
                               #0
                               sub { "DUMMY" }
                             ],
         "preamble" => [
                         #0
                         "<IfModule !mod_access_compat.c>\n    LoadModule access_compat_module \"/opt/apache/modules/mod_access_compat.so\"\n</IfModule>\n",
                         #1
                         "<IfModule !mod_auth_basic.c>\n    LoadModule auth_basic_module \"/opt/apache/modules/mod_auth_basic.so\"\n</IfModule>\n",
                         #2
                         "<IfModule !mod_socache_shmcb.c>\n    LoadModule socache_shmcb_module \"/opt/apache/modules/mod_socache_shmcb.so\"\n</IfModule>\n",
                         #3
                         "<IfModule !mod_socache_memcache.c>\n    LoadModule socache_memcache_module \"/opt/apache/modules/mod_socache_memcache.so\"\n</IfModule>\n",
                         #4
                         "<IfModule !mod_reqtimeout.c>\n    LoadModule reqtimeout_module \"/opt/apache/modules/mod_reqtimeout.so\"\n</IfModule>\n",
                         #5
                         "<IfModule !mod_filter.c>\n    LoadModule filter_module \"/opt/apache/modules/mod_filter.so\"\n</IfModule>\n",
                         #6
                         "<IfModule !mod_mime.c>\n    LoadModule mime_module \"/opt/apache/modules/mod_mime.so\"\n</IfModule>\n",
                         #7
                         "<IfModule !mod_log_config.c>\n    LoadModule log_config_module \"/opt/apache/modules/mod_log_config.so\"\n</IfModule>\n",
                         #8
                         "<IfModule !mod_env.c>\n    LoadModule env_module \"/opt/apache/modules/mod_env.so\"\n</IfModule>\n",
                         #9
                         "<IfModule !mod_headers.c>\n    LoadModule headers_module \"/opt/apache/modules/mod_headers.so\"\n</IfModule>\n",
                         #10
                         "<IfModule !mod_setenvif.c>\n    LoadModule setenvif_module \"/opt/apache/modules/mod_setenvif.so\"\n</IfModule>\n",
                         #11
                         "<IfModule !mod_version.c>\n    LoadModule version_module \"/opt/apache/modules/mod_version.so\"\n</IfModule>\n",
                         #12
                         "<IfModule !mod_proxy.c>\n    LoadModule proxy_module \"/opt/apache/modules/mod_proxy.so\"\n</IfModule>\n",
                         #13
                         "<IfModule !mod_proxy_http.c>\n    LoadModule proxy_http_module \"/opt/apache/modules/mod_proxy_http.so\"\n</IfModule>\n",
                         #14
                         "<IfModule !mod_proxy_balancer.c>\n    LoadModule proxy_balancer_module \"/opt/apache/modules/mod_proxy_balancer.so\"\n</IfModule>\n",
                         #15
                         "<IfModule !mod_slotmem_shm.c>\n    LoadModule slotmem_shm_module \"/opt/apache/modules/mod_slotmem_shm.so\"\n</IfModule>\n",
                         #16
                         "<IfModule !mod_lbmethod_byrequests.c>\n    LoadModule lbmethod_byrequests_module \"/opt/apache/modules/mod_lbmethod_byrequests.so\"\n</IfModule>\n",
                         #17
                         "<IfModule !mod_lbmethod_bytraffic.c>\n    LoadModule lbmethod_bytraffic_module \"/opt/apache/modules/mod_lbmethod_bytraffic.so\"\n</IfModule>\n",
                         #18
                         "<IfModule !mod_lbmethod_bybusyness.c>\n    LoadModule lbmethod_bybusyness_module \"/opt/apache/modules/mod_lbmethod_bybusyness.so\"\n</IfModule>\n",
                         #19
                         "<IfModule !mod_lbmethod_heartbeat.c>\n    LoadModule lbmethod_heartbeat_module \"/opt/apache/modules/mod_lbmethod_heartbeat.so\"\n</IfModule>\n",
                         #20
                         "<IfModule !mod_unixd.c>\n    LoadModule unixd_module \"/opt/apache/modules/mod_unixd.so\"\n</IfModule>\n",
                         #21
                         "<IfModule !mod_status.c>\n    LoadModule status_module \"/opt/apache/modules/mod_status.so\"\n</IfModule>\n",
                         #22
                         "<IfModule !mod_autoindex.c>\n    LoadModule autoindex_module \"/opt/apache/modules/mod_autoindex.so\"\n</IfModule>\n",
                         #23
                         "<IfModule !mod_info.c>\n    LoadModule info_module \"/opt/apache/modules/mod_info.so\"\n</IfModule>\n",
                         #24
                         "<IfModule !mod_dir.c>\n    LoadModule dir_module \"/opt/apache/modules/mod_dir.so\"\n</IfModule>\n",
                         #25
                         "<IfModule !mod_alias.c>\n    LoadModule alias_module \"/opt/apache/modules/mod_alias.so\"\n</IfModule>\n",
                         #26
                         "<IfModule !mod_mime.c>\n    LoadModule mime_module \"/usr/lib64/httpd/modules/mod_mime.so\"\n</IfModule>\n",
                         #27
                         "<IfModule !mod_alias.c>\n    LoadModule alias_module \"/usr/lib64/httpd/modules/mod_alias.so\"\n</IfModule>\n",
                         #28
                         "\n"
                       ],
         "vars" => {
                     "defines" => "",
                     "cgi_module_name" => "mod_cgi",
                     "conf_dir" => "/etc/httpd/conf",
                     "t_conf_file" => "/home/mkandel/src/POC/apache_testing/ariba_tests/framework/t/conf/httpd.conf",
                     "t_dir" => "/home/mkandel/src/POC/apache_testing/ariba_tests/framework/t",
                     "cgi_module" => "mod_cgi.c",
                     "target" => "httpd",
                     "thread_module" => "worker.c",
                     "bindir" => "/usr/bin",
                     "user" => "mkandel",
                     "access_module_name" => "mod_access",
                     "auth_module_name" => "mod_auth_basic",
                     "top_dir" => "/home/mkandel/src/POC/apache_testing/ariba_tests/framework",
                     "httpd_conf" => "/opt/apache/conf/httpd.conf",
                     "httpd" => "/opt/apache/bin/httpd",
                     "scheme" => "http",
                     "ssl_module_name" => "mod_ssl",
                     "port" => 8529,
                     "sbindir" => "/usr/sbin",
                     "t_conf" => "/home/mkandel/src/POC/apache_testing/ariba_tests/framework/t/conf",
                     "servername" => "localhost",
                     "inherit_documentroot" => "/opt/apache/htdocs",
                     "proxy" => "off",
                     "serveradmin" => "you\@example.com",
                     "authname" => "Ariba, Inc.",
                     "remote_addr" => "127.0.0.1",
                     "perlpod" => "/usr/local/lib/perl5/5.16.3/pod",
                     "sslcaorg" => "asf",
                     "php_module_name" => "sapi_apache2",
                     "maxclients_preset" => 0,
                     "php_module" => "sapi_apache2.c",
                     "ssl_module" => "mod_ssl.c",
                     "auth_module" => "mod_auth_basic.c",
                     "access_module" => "mod_access.c",
                     "t_logs" => "/home/mkandel/src/POC/apache_testing/ariba_tests/framework/t/logs",
                     "minclients" => 1,
                     "maxclients" => 2,
                     "group" => "ariba",
                     "t_pid_file" => "/home/mkandel/src/POC/apache_testing/ariba_tests/framework/t/logs/httpd.pid",
                     "maxclientsthreadedmpm" => 2,
                     "thread_module_name" => "worker",
                     "documentroot" => "/home/mkandel/src/POC/apache_testing/ariba_tests/framework/t/htdocs",
                     "serverroot" => "/home/mkandel/src/POC/apache_testing/ariba_tests/framework/t",
                     "sslca" => "/home/mkandel/src/POC/apache_testing/ariba_tests/framework/t/conf/ssl/ca",
                     "perl" => "/usr/local/bin/perl",
                     "src_dir" => undef,
                     "proxyssl_url" => ""
                   },
         "clean" => {
                      "files" => {
                                   "/home/mkandel/src/POC/apache_testing/ariba_tests/framework/t/conf/httpd.conf" => 1,
                                   "/home/mkandel/src/POC/apache_testing/ariba_tests/framework/t/htdocs/index.html" => 1,
                                   "/home/mkandel/src/POC/apache_testing/ariba_tests/framework/t/logs/apache_runtime_status.sem" => 1,
                                   "/home/mkandel/src/POC/apache_testing/ariba_tests/framework/t/conf/apache_test_config.pm" => 1
                                 },
                      "dirs" => {
                                  "/home/mkandel/src/POC/apache_testing/ariba_tests/framework/t/conf" => 1,
                                  "/home/mkandel/src/POC/apache_testing/ariba_tests/framework/t/logs" => 1,
                                  "/home/mkandel/src/POC/apache_testing/ariba_tests/framework/t" => 1,
                                  "/home/mkandel/src/POC/apache_testing/ariba_tests/framework/t/htdocs" => 1
                                }
                    },
         "httpd_info" => {
                           "BUILT" => "Jun  3 2013 12:51:52",
                           "MODULE_MAGIC_NUMBER_MINOR" => 11,
                           "SERVER_MPM" => "prefork",
                           "VERSION" => "Apache/2.4.4 (Unix)",
                           "MODULE_MAGIC_NUMBER" => "20120211:11",
                           "MODULE_MAGIC_NUMBER_MAJOR" => 20120211
                         },
         "modules" => {
                        "mod_headers.c" => "/opt/apache/modules/mod_headers.so",
                        "mod_env.c" => "/opt/apache/modules/mod_env.so",
                        "mod_auth_basic.c" => "/opt/apache/modules/mod_auth_basic.so",
                        "mod_lbmethod_byrequests.c" => "/opt/apache/modules/mod_lbmethod_byrequests.so",
                        "mod_version.c" => "/opt/apache/modules/mod_version.so",
                        "mod_lbmethod_bytraffic.c" => "/opt/apache/modules/mod_lbmethod_bytraffic.so",
                        "mod_proxy_balancer.c" => "/opt/apache/modules/mod_proxy_balancer.so",
                        "mod_proxy.c" => "/opt/apache/modules/mod_proxy.so",
                        "core.c" => 1,
                        "mod_socache_shmcb.c" => "/opt/apache/modules/mod_socache_shmcb.so",
                        "http_core.c" => 1,
                        "mod_setenvif.c" => "/opt/apache/modules/mod_setenvif.so",
                        "mod_dir.c" => "/opt/apache/modules/mod_dir.so",
                        "mod_lbmethod_heartbeat.c" => "/opt/apache/modules/mod_lbmethod_heartbeat.so",
                        "mod_filter.c" => "/opt/apache/modules/mod_filter.so",
                        "mod_reqtimeout.c" => "/opt/apache/modules/mod_reqtimeout.so",
                        "mod_unixd.c" => "/opt/apache/modules/mod_unixd.so",
                        "prefork.c" => 1,
                        "mod_access_compat.c" => "/opt/apache/modules/mod_access_compat.so",
                        "mod_so.c" => 1,
                        "mod_proxy_http.c" => "/opt/apache/modules/mod_proxy_http.so",
                        "mod_socache_memcache.c" => "/opt/apache/modules/mod_socache_memcache.so",
                        "mod_alias.c" => "/opt/apache/modules/mod_alias.so",
                        "mod_lbmethod_bybusyness.c" => "/opt/apache/modules/mod_lbmethod_bybusyness.so",
                        "mod_autoindex.c" => "/opt/apache/modules/mod_autoindex.so",
                        "mod_status.c" => "/opt/apache/modules/mod_status.so",
                        "mod_log_config.c" => "/opt/apache/modules/mod_log_config.so",
                        "mod_mime.c" => "/opt/apache/modules/mod_mime.so",
                        "mod_info.c" => "/opt/apache/modules/mod_info.so",
                        "mod_slotmem_shm.c" => "/opt/apache/modules/mod_slotmem_shm.so"
                      },
         "httpd_defines" => {
                              "SUEXEC_BIN" => "/opt/apache/bin/suexec",
                              "APR_HAS_MMAP" => 1,
                              "APR_HAS_OTHER_CHILD" => 1,
                              "DEFAULT_PIDLOG" => "logs/httpd.pid",
                              "DYNAMIC_MODULE_LIMIT" => 256,
                              "AP_TYPES_CONFIG_FILE" => "conf/mime.types",
                              "DEFAULT_SCOREBOARD" => "logs/apache_runtime_status",
                              "APR_USE_SYSVSEM_SERIALIZE" => 1,
                              "APR_HAVE_IPV6 (IPv4-mapped addresses enabled)" => 1,
                              "SINGLE_LISTEN_UNSERIALIZED_ACCEPT" => 1,
                              "DEFAULT_ERRORLOG" => "logs/error_log",
                              "APR_HAS_SENDFILE" => 1,
                              "HTTPD_ROOT" => "/opt/apache",
                              "AP_HAVE_RELIABLE_PIPED_LOGS" => 1,
                              "APR_USE_PTHREAD_SERIALIZE" => 1,
                              "SERVER_CONFIG_FILE" => "conf/httpd.conf"
                            },
         "apache_test_version" => "1.38"
       }, 'Apache::TestConfig' );
}

1;
