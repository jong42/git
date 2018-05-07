package de.c3e;

import java.io.IOException;
import java.util.*;

import org.apache.hadoop.fs.Path;
import org.apache.hadoop.conf.*;
import org.apache.hadoop.io.*;
import org.apache.hadoop.mapred.*;
import org.apache.hadoop.util.*;

/**
* Intruduciton class on iterations in haddop.
*/
public class IterationIntroduction
{
  /**
  * Mapper-class:
  * Inputs:
  *    Key    : File Id (long)
  *    Value  : Line of text (Text)
  *
  * Outputs:
  *    Key    : Key (int) => regulate number of reducers
  *    Value  : Parsed value (int)
  **/
  public static class Map extends MapReduceBase implements Mapper<LongWritable, Text, Text, IntWritable>
  {
    public void map(LongWritable fileId, Text inputText, OutputCollector<Text, IntWritable> output, Reporter reporter) throws IOException
    {
      String line = inputText.toString().trim();
      try
      {
        Integer value = Integer.parseInt(line);
        output.collect(new Text("foo"), new IntWritable(value));
      }
      catch (Exception e)
      {
        System.out.println("Could not parse to Int: " +  line );
      }
    }
  }

  /**
  * Reducer-class:
  * Inputs:
  *    Key    : Key (int) => regulate number of reducers
  *    Values : list of parsed values (int)
  *
  * Outputs:
  *    Key    : not needed (String) => will be ""
  *    Value  : incremented value (int)
  **/
  public static class Reduce extends MapReduceBase implements Reducer<Text, IntWritable, Text, IntWritable>
  {
    public void reduce(Text key, Iterator<IntWritable> values, OutputCollector<Text, IntWritable> output, Reporter reporter) throws IOException
    {
      while (values.hasNext())
      {
        output.collect( new Text(" "), new IntWritable(values.next().get() + 1));
      }
    }
  }

  public static void main(String[] args) throws Exception
  {
    String inputBasePath = args[0];
    String outputBasePath = args[1];
    String iterationString = args[2];

    int iterations = 1;
    try
    {
      iterations = Integer.parseInt(iterationString);
    }
    catch (Exception e)
    {
      System.out.println("Could not parse to Int: " +  iterationString );
    }

    JobConf conf = new JobConf(IterationIntroduction.class);
    conf.setJobName("IterationIntroduction");

    conf.setOutputKeyClass(Text.class);
    conf.setOutputValueClass(IntWritable.class);

    conf.setMapperClass(Map.class);
    // conf.setCombinerClass(Reduce.class); // don't use a combiner. this would mean +2
    conf.setReducerClass(Reduce.class);

    conf.setInputFormat(TextInputFormat.class);
    conf.setOutputFormat(TextOutputFormat.class);

    String lastOutputPath = inputBasePath;
    for (int i=0;i<iterations;i++)
    {
      String currentOutputPath = outputBasePath + "/run" + i ;

      FileInputFormat.setInputPaths(conf, new Path(lastOutputPath));
      FileOutputFormat.setOutputPath(conf, new Path(currentOutputPath));
      JobClient.runJob(conf);

      lastOutputPath = currentOutputPath;
    }
  }
}
