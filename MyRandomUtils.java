
package com.weimob.tjpm.hive.hook;

import com.alibaba.fastjson.JSON;
import com.google.common.collect.Maps;
import lombok.AllArgsConstructor;
import lombok.Data;
import org.apache.commons.lang.math.RandomUtils;

import java.util.*;
import java.util.Map.Entry;

/**
 * @author zhangwei13
 */

public class MyRandomUtils5 {

    @Data
    public static class PriorityCycle {

        private Random r = new Random();
        public int maxFan = 0;
        public TreeMap<Integer, PrioritySection> cycles;

        public void reset(Collection<PrioritySection> pss) {
            cycles = new TreeMap<Integer, PrioritySection>();
            maxFan = 0;

            int cycleIncrement = 0;
            for (PrioritySection ps : pss) {
                cycles.put(cycleIncrement, ps);
                cycleIncrement += ps.getPriority();
                maxFan = cycleIncrement;
            }
        }

        public void put(Integer fanSize, PrioritySection ps) {
            cycles.put(fanSize, ps);
        }

        public PrioritySection dice() {
            Integer random = RandomUtils.nextInt(r, maxFan);
            if (null != random) {
                Entry<Integer, PrioritySection> entry = cycles.floorEntry(random);
                if (null != entry) {
                    return entry.getValue();
                }
            }
            return null;
        }

        public PriorityCycle(Collection<PrioritySection> pss) {
            reset(pss);
        }
    }

    @Data
    @AllArgsConstructor
    public static class PrioritySection {
        public String id;
        public int priority;
    }

    @Data
    public static class Shuffler {

        private PriorityCycle priorityCycle = null;
        private TreeMap<String, Integer> players = null;
        int shuffleNums = 0;

        public void start(Collection<PrioritySection> pss) {
            priorityCycle = new PriorityCycle(pss);
        }

        public String shuffle() {

            if (shuffleNums <= 0) {
                players = new TreeMap<String, Integer>();
                shuffleNums = priorityCycle.getMaxFan();
            }

            while (true) {
                PrioritySection ps = priorityCycle.dice();
                Integer c = players.get(ps.getId());
                if (c == null) {
                    c = 0;
                }
                if ((c + 1) <= ps.getPriority()) {
                    players.put(ps.getId(), c + 1);
                    shuffleNums--;
                    return ps.getId();
                }
            }
        }
    }

    public static void main(String[] args) {

        Collection<PrioritySection> pss = Arrays.asList(
                new PrioritySection("player1", 4),
                new PrioritySection("player2", 6));

        Shuffler shuffler = new Shuffler();
        shuffler.start(pss);

        Map<String, Integer> players = Maps.newHashMap();
        int i = 1000000;
        while (i-- > 0) {
            String playId = shuffler.shuffle();
            Integer c = players.get(playId);
            if (c == null) {
                c = 0;
            }
            players.put(playId, c + 1);
            System.out.println(JSON.toJSONString(players));
        }
    }
}
