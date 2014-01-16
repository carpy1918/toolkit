import org.jrobin.core.*;
import java.io.*;

public class generateReports
{

public static void main (String[] args) {

String rrdfile = "";
Time stop = valueOf("12:00:00");
long stopl = start.getTime();
long startl = stopl - 604800000;

RrdDb rrd = new RrdDb($rrdfile);
FetchRequest request = rrd.createFetchRequest("AVERAGE", $startl, $stopl);
FetchPoint[] points = request.fetch();

for(int i = 0; i < points.length; i++) 
{
   System.out.println(points[i].dump());
}

} //end main

} //end generateReports
