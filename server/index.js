const express = require("express");
const bodyParser = require("body-parser");

const app = express();

let goal = "Learn DevOps";

app.use(bodyParser.urlencoded({ extended: false }));

app.use(express.static("public"));

app.get("/", (req, res) => {
  res.send(`
    <html>
        <head>
            <title>${goal}</title>
            <link rel='stylesheet' href='style.css'>
        </head>
        <body>
            <h1 class='title'>Learning DevOps From Scratch</h1>
            <h3 class='subtitle'>Docker</h3>
            <p>Learn how to containerize applications</p>
            <h3 class='subtitle'>Kubernetes</h3>
            <p>Learn how to orchestrate containers</p>
            <h3 class='subtitle'>CI/CD</h3>
            <p>Learn how to automate the deployment process</p>
        </body>
    </html>
    `);
});

app.post("/goal", (req, res) => {
  goal = req.body.goal;
  console.log("Goal updated to:", goal);
  res.redirect("/");
});

app.listen(3000, () => {
  console.log("Server running on port 3000");
  console.log("http://localhost:3000");
});
