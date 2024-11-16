import express from "express";
import { solve } from "./minizinc";
const app = express();
const port = 3000;

app.use(express.json());

app.get("/", async (req, res) => {
  try {
    const params = {
      num_players: Number(req.body.num_players ?? 4),
      num_games: Number(req.body.num_games ?? 3),
      num_time_slots: Number(req.body.num_time_slots ?? 5),
      game_players: req.body.game_players ?? [
        [1, 2],
        [3, 4],
        [1, 3],
      ],
    };

    const solution = await solve(params);
    res.send({ params, solution });
  } catch (e) {
    res.send(e);
  }
});

app.listen(port, () => {
  return console.log(`Express is listening at http://localhost:${port}`);
});
