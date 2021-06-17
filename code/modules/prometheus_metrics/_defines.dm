#define PROMETHEUS_METRIC_COUNTER 0
#define PROMETHEUS_METRIC_GAUGE 1

GLOBAL_LIST_INIT(prometheus_metric_names, list("counter", "gauge"))
#define PROMETHEUS_METRIC_NAME(m) GLOB.prometheus_metric_names[m + 1]
