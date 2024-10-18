package org.example;

import org.um.feri.ears.problems.StopCriterionException;
import org.um.feri.ears.benchmark.RPCOe1Benchmark;

public class App {

    public static void main(String[] args) throws StopCriterionException {
        var algorithm = new GWO();
        var benchmark = new RPCOe1Benchmark();
        benchmark.initAllProblems(); //manually initialize problems

        var tasks = benchmark.getAllTasks();
        int numberOfRuns = benchmark.getNumberOfRuns();

        for (var t: tasks) {
            StringBuilder sb = new StringBuilder();
            sb.append(algorithm.getAlgorithmInfoCSV()).append(";").append(t.getTaskInfoCSV());
            sb.append("\n");

            for (int i = 0; i < numberOfRuns; i++) {
                var result = algorithm.execute(t);

                sb.append(result.getEval());
                if(i+1 < numberOfRuns)
                    sb.append("\n");
                t.resetCounter();
            }
            System.out.println(sb);
        }
    }
}