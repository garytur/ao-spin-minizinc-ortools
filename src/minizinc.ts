import * as MiniZinc from "minizinc";

export const solve = async (params: {
  num_players: number;
  num_games: number;
  num_time_slots: number;
  game_players: number[][];
}) => {
  try {
    await MiniZinc.init({
      minizinc: "minizinc",
    });

    const model = new MiniZinc.Model();

    model.addFile("schedule.mzn");
    model.addJson(params);

    const solve = model.solve({
      options: {
        solver: "cp-sat",
        "time-limit": 10000,
        statistics: true,
      },
    });

    solve.on("solution", (solution) => console.log(solution.output.json));
    solve.on("statistics", (stats) => console.log(stats.statistics));

    const result = await solve;

    return result;
  } catch (e) {
    console.error(`Got error`);
    console.log(e);
    throw e;
  }
};

if (require.main === module) {
  (async () => {
    const res = await solve({
      num_players: 4,
      num_games: 3,
      num_time_slots: 5,
      game_players: [
        [1, 2],
        [3, 4],
        [1, 3],
      ],
    });

    console.log(res);
  })();
}
