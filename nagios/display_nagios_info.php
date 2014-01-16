<?php
/*
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
// Launch timer
$start_utime = microtime(true);
$dump_graphic = $_GET["dump_graphic"];

include_once("./nagios_graph_conf.inc.php");

if(count($name1) == 0 || count($name2) == 0) {
  include_once('./choose_nagios.php');
  return;
}

$request = "
SELECT
  DISTINCT object_id, name1, name2
FROM
  nagios_objects
WHERE
  ";
$request .= "name1 IN ('".implode($name1,"','")."') AND ";
$request .= "name2 IN ('".implode($name2,"','")."')";
if(count($name1) > 1)
  $multiple_host = true;
else
  $multiple_host = false;

print "SQL Query: " . $request . "\n";

$nagios_result = mysql_query($request, $nagios_connection);
while($result = mysql_fetch_row($nagios_result)) {		
  $object_id []= $result[0];			#nagios_objects - object_id
  $id_to_name1[$result[0]] = $result[1];	#nagios_objects - name1
  $id_to_name2[$result[0]] = $result[2];	#nagios_objects - name2
}
if(count($object_id) == 0) {
  print "<h2 style='text-align:center'>"._("Error while fetching data from nagios DB.")."</h2>";

  include_once('./choose_nagios.php');
  return;
}
$current_timestamp = $start_timestamp;
$table_to_fetch = array();
while($current_timestamp <= ($end_timestamp + 3600*24)) {
  $request_table = "SHOW TABLES LIKE 'nagios_servicechecks_".date("Ymd", $current_timestamp)."'";
  $mysql_result = mysql_query($request_table, $nagios_connection);
  if($table = mysql_fetch_row($mysql_result)) {
    $table_to_fetch []= $table[0];
  }
  $current_timestamp = strtotime("+1 day", $current_timestamp);
}
$table_to_fetch []= "nagios_servicechecks";		#MYSQL table

$prefetch_utime = microtime(true);

$cumulate = false;
if(strlen($_GET["cumulate"]) > 0) {
  $cumulate = $_GET["cumulate"];
}

if(!$dump_graphic)
  include_once("./nagios_head.inc.php");
$export = "<h1 style='text-align:center'>"._("CSV Export")."</h1>\n<pre>";
$first_time = true;

$result = array();	#mysql query result
$values = array();	#split of perfdata field
$raw_datax = array();	#time field
$label_list = array();
$label_value = array();
$first_time = true;
// information extraction
$something_to_display = false;
foreach($table_to_fetch as $table) { 	#query nagios_servicechecks and nagios_objects for data
  $request = "			
SELECT
  UNIX_TIMESTAMP(start_time), output, perfdata, name1
FROM
  $table, nagios_objects
WHERE
  $table.service_object_id IN ('".implode("','", $object_id)."') AND
  $table.start_time > '$start' AND $table.start_time <= '$end' AND $table.service_object_id = nagios_objects.object_id
";
  if($cumulate) {
    $request .= "ORDER BY start_time";
  } else {
    $request .= "ORDER BY name1, start_time";
  }

  print "SQL Query: " . $request . "\n";

  $nagios_result = mysql_query($request, $nagios_connection);	#send query
  while($t_result = mysql_fetch_row($nagios_result)) {		#t_result - loop through mysql data
    $raw_datax []= $t_result[0];				#time of entry
    $line = array($t_result[0]);
    foreach(split(" ", $t_result[2]) as $elt) {			#split up the perfdata by " " 
      $value = split("=", $elt);				#split up by "="
      if(strlen($value[0]) == 0) continue;
      $label_list[$value[0]] = $value[0];			#perfdata component - probably field
      
      // Skip everything which is not corresponding to indicator
      if($indicator) {
        $skip = false;
        foreach($indicator as $indic) {
          if(strcmp($indic, $value[0]) != 0 && strcmp($indic, $value[0]."-".$t_result[3]) != 0 ) {	
            $result[$value[0]] = false;
            $skip = true;
          } else {
            $skip = false;
            break;
          }
        }
        if($skip) continue;
      }
      if($multiple_host && !$cumulate) {
        $value[0] = $value[0]."-".$t_result[3]; 		#date - service name
      }
      $i = 0;
      $skip = false;
      $tmp_data_value = split(";", $value[1]);			#perfdata component - probably value
      $check_sub = false;
      if(is_array($selected_sub_indicator)) {
        foreach($selected_sub_indicator as $sub)
          $skip_sub[$sub] = "keep";
        $check_sub = true;
      }
      foreach($tmp_data_value as $val) {			#make sure that perfdata has something or skip
        $label = $value[0];
        if($first_time)
          $result[$value[0]][$i][0] = $value[0];
        if($check_sub && strlen($skip_sub[$i]) == 0) { $i++; continue; }
        $something_to_display = true;
        $label_list[$label] = $value[0];
        $label_value[$value[0]] = $value[0];
        $values[$label][$i][] = (float)$val;
        $raw_datax[$label][$i][] = $t_result[0];
        $result[$label][$i++][] = $val + 0;
      }
      $line [] = $value[1];					#assigning perfdata, prob value, again to $linei[]
    } #end foreach, perfdata

    $export .= implode(";", $line)."\n";			#perfdata, prob value, to string
    print "perfdata - value: " . $export . "\n";
    $first_time = false;
  } #end while of mysql data


  $color_index = 0;
  $keys = array_keys($label_list);
  $first_time = true;
}

if(!$something_to_display) {
  print "<h2 style='text-align:center'>"._("No data to display")."</h2>";
  include_once('./choose_nagios.php');
  return;
}
$data_utime = microtime(true);



//
// Creating a new graph object
//



$graph = new Graph($size_x, $size_y, "auto");
// $graph->img->SetAntiAliasing();
$graph->SetScale("datlin");
$graph->ygrid->SetFill(true, '#EFEFEF@0.5', '#BBCCFF@0.5');
// $graph->xgrid->SetFill(true, '#EFEFEF@0.8', '#BBCCFF@0.8');
// $graph->xgrid->SetLineStyle('dashed');
$graph->xgrid->Show();
if(!$dump_graphic || strlen($_GET["start_date"]) > 0)
  $graph->title->Set(implode(", ", $name1)." / ".implode(", ", $name2)." : ".sprintf(_("Values between %s and %s"), $start, $end));
else
  $graph->title->Set(implode(", ", $name1)." / ".implode(", ", $name2)." ($default_time_period)");

// $cumulate = true;
$area = strcmp($graph_type, "cumulate_area") == 0;
$plot_area_list = array();
foreach($keys as $key) {
  $agregate_values = array();
  $agregate_datax = array();
  $elt = 0;
  for($i = 0; $i < count($result[$key]); $i++) {
    if(count($values[$key][$i]) == 0) continue;
    // compute avg values if need to compute an agregation
    if($agregate > 1 || count($name1) > 0) {
      // update of $j is done later in case of delta time bigger than 10 min to avoid bad result
      for($j = 0; $j < count($values[$key][$i]);/*$j += ($agregate * count($name1))*/) {
        $sum = 0; $sum_date = 0; $k_count = 0; $initial_j = $j; $limit = $j + ($agregate * count($name1));
        for($k = $j; $k < $limit && $k < count($values[$key][$i]); $k++) {
          // break is delta time is bigger than 10 min
          if($k > $initial_j && $raw_datax[$key][$i][$k] - $raw_datax[$key][$i][$k - 1] > 600) break;
          $sum += $values[$key][$i][$k];
          $sum_date += $raw_datax[$key][$i][$k];
          $k_count++;
          $j++;
        }
        $agregate_values[$elt] []= round($sum / ($cumulate ? $agregate : $k_count), 2);
        $agregate_datax[$elt]  []= round($sum_date / $k_count, 2);
      }
      $lineplot = new LinePlot($agregate_values[$elt], $agregate_datax[$elt]);
    } else {
      $lineplot = new LinePlot($values[$key][$i], $raw_datax[$key][$i]);
    }
    if(!$hide_legend) {
      $lineplot->SetLegend($label_list[$key].(strlen($sub_indicator[$i]) > 0 ? "-".$sub_indicator[$i] : ""));
    }
    $lineplot->SetWeight(1);
    $lineplot->mark->SetType(MARK_FILLEDCIRCLE);
    $lineplot->mark->SetFillColor($colors[$color_index]);
    $lineplot->mark->SetWidth(2);
    if($area) {
      $plot_area_list []= $lineplot;
      $lineplot->SetColor("gray");
      $lineplot->SetFillColor($colors[$color_index]);
    } else {
      $lineplot->SetColor($colors[$color_index]);
      $graph->Add($lineplot);
    }
    $color_index = ($color_index + 1) % count($colors);
    $elt++;
  }
}
if($area) {
  $point_area = new AccLinePlot($plot_area_list);
  $graph->Add($point_area);
}

$indicators = array_keys($label_list);
sort($indicators);

// setting fonts type
$graph->title->SetFont(FF_FONT1, FS_BOLD);
$graph->yaxis->title->SetFont(FF_FONT1, FS_BOLD);
$graph->xaxis->title->SetFont(FF_FONT1, FS_BOLD);
// legend ...
if(!$hide_legend) {
  if(!$dump_graphic)
    $graph->legend->Pos(0.06, 0.05, "left", "top");
  else
    $graph->legend->Pos(0.5, 0.08, "center", "top");
  $graph->legend->SetColumns(4);
}
$graph->yaxis->scale->SetAutoMin($min_value);
$graph->yaxis->scale->SetAutoMax($max_value);

// Setting marging + Date format (from unix timestamp to human beings date
$graph->xaxis->scale->SetDateFormat($date_format);
$graph->xaxis->SetLabelAngle(90);
if(!$dump_graphic) {
  $graph->SetMargin(60, 20, 50, 80);
} else {
  $graph->SetMargin(40, 20, 50, 45);
}
// Thanks solaris for your amazing choise of missing packages ...
// $graph->xaxis->SetFont(FF_ARIAL,FS_NORMAL,8);
$graph_utime = microtime(true);
//$graph->xaxis->scale->SetMax($end_timestamp);

if($output_raw_value)
  print $export."</pre>\n";

// Display the graph
if(!$dump_graphic) {
  $graph->Stroke("$cache_directory/$picture_name.png");
  print("<h2 style='text-align: center'>Generated graphic :</h2>\n");
  print("<p style='text-align: center'><img src='$cache_htdocs/$picture_name.png' /></p>\n");
  $short_date = date("Ymd", $end_timestamp);
  $year = date("Y", $end_timestamp);
  $month = date("m", $end_timestamp);
  $day = date("d", $end_timestamp);
  print("<script type=\"text/javascript\">
<!--

function ImageNavigator(prefix, year, month, day) {
  // Init class properties
  this.prefix   = prefix;
  this.year     = year;
  this.month    = month - 1;
  this.day      = day;
  this.temp_day = day;
  this.valid    = true;
  this.calendar = new Date();
  this.updateCalendar();
  this.updateDateString();
}

ImageNavigator.prototype.setPrefix = function(prefix) {
  this.prefix = prefix;
}

ImageNavigator.prototype.validate = function(prefix) {
  this.day = this.temp_day;
}

ImageNavigator.prototype.updateCalendar = function() {
  this.calendar.setDate(this.day);
  this.calendar.setMonth(this.month);
  this.calendar.setYear(this.year);
  this.day   = this.calendar.getDate();
  this.month = this.calendar.getMonth();
  this.year  = this.calendar.getFullYear();
};

ImageNavigator.prototype.updateDateString = function() {
  this.date_string = this.year;
  if(this.month < 9)
    this.date_string += '0' + (this.month + 1);
  else
    this.date_string += (this.month + 1);
  if(this.temp_day < 10)
    this.date_string += '0' + this.temp_day;
  else
    this.date_string += this.temp_day;
};
ImageNavigator.prototype.getDateString = function() {
  return this.date_string;
};
ImageNavigator.prototype.next = function() {
  this.temp_day = this.day + 1;
  this.updateDateString();
}
ImageNavigator.prototype.previous = function() {
  this.temp_day = this.day - 1;
  this.updateDateString();
};

ImageNavigator.prototype.getImageString = function() {
  return this.prefix+this.date_string+'.png';
};

ImageNavigator.prototype.getNextImageString = function() {
  this.next();
  return this.getImageString();
};

ImageNavigator.prototype.getPreviousImageString = function() {
  this.previous();
  return this.getImageString();
};

var prev_good_value = false;
function switch_content(img_src, img_dest) {
  if(!prev_good_value)
    prev_good_value = document.getElementById(img_src).src;

  if(document.getElementById(img_src).width > 0) {
    document.getElementById(img_dest).src = document.getElementById(img_src).src;
  } else {
    document.getElementById(img_src).src = prev_good_value;
  }
}

// Do not load img directly in case this image doesn't exist
function upload_temp_img(img_src, img_temp) {
  document.getElementById(img_temp).src = img_src;
}

//-->
</script>");
  foreach($name1 as $host) {
    foreach($name2 as $service) {
      foreach(array("month", "week", "day") as $period) {
        $img_prefix = "$pre_generated_image_path/$host/$service-$period-";
        $img_name = "$img_prefix".date("Ymd", $end_timestamp).".png";
        if(file_exists("$img_name")) {
          print("<script type=\"text/javascript\">\n");
          print("<!--\n");
          print("var ".$period."_navigator = new ImageNavigator('$img_prefix', $year, $month, $day);");
          print("//-->");
          print("</script>");
          print "<img style='display: none;' src='$img_name' id='test_img_$period' ". // onload event to switch between temp and real img
                "onLoad=\"switch_content('test_img_$period', '".$period."_view');".$period."_navigator.validate();\" />\n";
          print("<h2 style='text-align: center'>$period graphic :</h2>\n");
          print("<p style='text-align: center'>".
                "<a href='javascript:' onclick=\"upload_temp_img(".$period."_navigator.getPreviousImageString(), 'test_img_$period');\">".
                "&lt;&lt; -1 day</a><img src='$img_name' id='".$period."_view' align='middle' />".
                "<a href='javascript:' onclick=\"upload_temp_img(".$period."_navigator.getNextImageString(), 'test_img_$period');\">".
                "+1 day &gt;&gt;</a></p>\n");
        }
      }
    }
  }
} else {
  $graph->Stroke();
  exit(0);
}

$end_utime = microtime(true);
$total_rendering_time = round($end_utime - $start_utime, 3);
$prefetch_processing_time = round($prefetch_utime - $start_utime, 3);
$data_processing_time = round($data_utime - $prefetch_utime, 3);
$graph_rendering_time = round($end_utime - $graph_utime, 3);

printf("<div style='text-align: center'>".sprintf(_("Page generated in %s s (%s s spent prefetching data, %s s spent fetching data and %s s generating graphics).</div>"),
                                                  $total_rendering_time, $prefetch_processing_time, $data_processing_time, $graph_rendering_time));

include_once('./choose_nagios.php');
include_once('./nagios_foot.inc.php');
?>
