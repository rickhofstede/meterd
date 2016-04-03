#!/bin/bash

DB_DIR="/var/meterd"
DST_PATH="/var/www/html/img/gas-week.svg"

log_error () {
	printf "ERROR: ${*}\n"
	exit 1
}

# Check for availability of gnuplot
if [ "$(which gnuplot 2> /dev/null)" == "" ]; then
	log_error "gnuplot is not installed\n"
fi

# Check whether files and directories are present
if [ ! -d ${DB_DIR} ]; then
	log_error "Database directory (${DB_DIR}) not found"
fi

# Check whether destination directory exists
if [ ! -d $(dirname ${DST_PATH}) ]; then
	log_error "Destination directory ($(dirname ${DST_PATH})) not found"
fi

# Check whether destination path is writable
if [ ! -w $(dirname ${DST_PATH}) ]; then
	log_error "Destination directory ($(dirname ${DST_PATH})) not writable"
fi

gnuplot <<EOF
set terminal svg size 800,600
set output '${DST_PATH}'
set title "One week gas consumption"
set xlabel "Time (UTC)"
set ylabel "Consumption in m3"
set xdata time
set timefmt "%s"
set xtics 86400
set format x "%d/%m"
`cat ${DB_DIR}/gas.week.ranges`
plot "${DB_DIR}/gas.week" using 1:2 title "consumption" with lines
EOF
