#!/bin/bash

# Check the number of parameters
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <parameter>"
    echo "Parameters:"
    echo "  1 - All entries sorted by response code"
    echo "  2 - All unique IPs found in the entries"
    echo "  3 - All requests with errors (response code - 4xx or 5xx)"
    echo "  4 - All unique IPs found among error requests"
    exit 1
fi

# Parameter
option="$1"

# Path to the log directory
log_dir="/home/zekemath/ex4"

# Check if log files exist
if ! ls "$log_dir"/nginx_log_day_*.log > /dev/null 2>&1; then
    echo "Error: No log files found in $log_dir matching the pattern nginx_log_day_*.log"
    exit 1
fi

# Function to process logs
process_logs() {
    case "$option" in
        1)
            # All entries sorted by response code
            sudo goaccess "$log_dir"/nginx_log_day_*.log --log-format='%h %^[%d:%t %^] "%r" %s %b "%R" "%u"' --date-format='%d/%b/%Y' --time-format='%H:%M:%S' --real-time-html --port=7890 --addr=127.0.0.1 --output=report_response_code.html
            ;;
        2)
            # All unique IPs found in the entries
            sudo goaccess "$log_dir"/nginx_log_day_*.log --log-format='%h %^[%d:%t %^] "%r" %s %b "%R" "%u"' --date-format='%d/%b/%Y' --time-format='%H:%M:%S' --real-time-html --port=7890 --addr=127.0.0.1 --output=report_unique_ips.html
            ;;
        3)
            # All requests with errors (response code - 4xx or 5xx)
            sudo goaccess "$log_dir"/nginx_log_day_*.log --log-format='%h %^[%d:%t %^] "%r" %s %b "%R" "%u"' --date-format='%d/%b/%Y' --time-format='%H:%M:%S' --real-time-html --port=7890 --addr=127.0.0.1 --output=report_error_requests.html
            ;;
        4)
            # All unique IPs found among error requests
            sudo goaccess "$log_dir"/nginx_log_day_*.log --log-format='%h %^[%d:%t %^] "%r" %s %b "%R" "%u"' --date-format='%d/%b/%Y' --time-format='%H:%M:%S' --real-time-html --port=7890 --addr=127.0.0.1 --output=report_error_unique_ips.html
            ;;
        *)
            echo "Invalid parameter. Use 1, 2, 3, or 4."
            exit 1
            ;;
    esac

    echo "Report generated. Open the following file in your browser:"
    echo "http://127.0.0.1:7890"
}

# Call the function to process logs
process_logs