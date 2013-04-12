# monolith aggregator.
define monolith::aggregator_instance(
    $project_dir
) {
    $aggr_name = $name
    cron {
        $aggr_name:
            command => "cd ${project_dir}/current/; ./venv/bin/monolith-extract --date yesterday configs/monolith.ini >> /var/log/${aggr_name}.cron.log 2>&1",
            user    => root,
            hour    => 1,
            minute  => 0;
    }
}
