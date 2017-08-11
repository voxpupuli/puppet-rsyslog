class rsyslog::config::lookup_tables {
  $::rsyslog::config::lookup_tables.each |$table, $config| {
    rsyslog::component::lookup_table { $table:
      * => {
        'target' => $::rsyslog::target_file,
      } + $config,
    }
  }
}