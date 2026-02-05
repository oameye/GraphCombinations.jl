window.BENCHMARK_DATA = {
  "lastUpdate": 1746212935797,
  "repoUrl": "https://github.com/oameye/GraphCombinations.jl",
  "entries": {
    "Benchmark Results": [
      {
        "commit": {
          "author": {
            "email": "orjan.ameye@hotmail.com",
            "name": "Orjan Ameye",
            "username": "oameye"
          },
          "committer": {
            "email": "orjan.ameye@hotmail.com",
            "name": "Orjan Ameye",
            "username": "oameye"
          },
          "distinct": true,
          "id": "2b965ff08c24399c8dedb8422109b1c7ed5a9261",
          "message": "update $ϕ^4$ Feynman Diagram example",
          "timestamp": "2025-05-01T16:34:24+02:00",
          "tree_id": "2db1c00b1f74d8a6f3f7cded43bc35e189c561c6",
          "url": "https://github.com/oameye/GraphCombinatorics.jl/commit/2b965ff08c24399c8dedb8422109b1c7ed5a9261"
        },
        "date": 1746110165721,
        "tool": "julia",
        "benches": [
          {
            "name": "Phi^4 theory/3 loops",
            "value": 778154805,
            "unit": "ns",
            "extra": "gctime=125142018.5\nmemory=1114152384\nallocs=10297695\nparams={\"gctrial\":true,\"time_tolerance\":0.05,\"evals_set\":false,\"samples\":10000,\"evals\":1,\"gcsample\":false,\"seconds\":10,\"overhead\":0,\"memory_tolerance\":0.01}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 1553999,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3861696\nallocs=39972\nparams={\"gctrial\":true,\"time_tolerance\":0.05,\"evals_set\":false,\"samples\":10000,\"evals\":1,\"gcsample\":false,\"seconds\":10,\"overhead\":0,\"memory_tolerance\":0.01}"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "orjan.ameye@hotmail.com",
            "name": "Orjan Ameye",
            "username": "oameye"
          },
          "committer": {
            "email": "noreply@github.com",
            "name": "GitHub",
            "username": "web-flow"
          },
          "distinct": true,
          "id": "cf134e0f070ac8c939d1ef4cc1dd9f96ec9eda22",
          "message": "fix: `corr` type instability  (#3)",
          "timestamp": "2025-05-02T12:40:59+02:00",
          "tree_id": "95fad0423549fc95a47105c708a8a5323ed3fb49",
          "url": "https://github.com/oameye/GraphCombinatorics.jl/commit/cf134e0f070ac8c939d1ef4cc1dd9f96ec9eda22"
        },
        "date": 1746182540584,
        "tool": "julia",
        "benches": [
          {
            "name": "Phi^4 theory/3 loops",
            "value": 706968516,
            "unit": "ns",
            "extra": "gctime=115887359\nmemory=1107673856\nallocs=10027936\nparams={\"gctrial\":true,\"time_tolerance\":0.05,\"evals_set\":false,\"samples\":10000,\"evals\":1,\"gcsample\":false,\"seconds\":10,\"overhead\":0,\"memory_tolerance\":0.01}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 1492605.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3824352\nallocs=38593\nparams={\"gctrial\":true,\"time_tolerance\":0.05,\"evals_set\":false,\"samples\":10000,\"evals\":1,\"gcsample\":false,\"seconds\":10,\"overhead\":0,\"memory_tolerance\":0.01}"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "orjan.ameye@hotmail.com",
            "name": "Orjan Ameye",
            "username": "oameye"
          },
          "committer": {
            "email": "noreply@github.com",
            "name": "GitHub",
            "username": "web-flow"
          },
          "distinct": true,
          "id": "d9ae3f3ee7d6c757aa3947a25b60a0eb0dafd768",
          "message": "feat: correctly plot graphs with GraphMakie (#4)",
          "timestamp": "2025-05-02T16:00:53+02:00",
          "tree_id": "cc4c18eee07591e6ae509a7bcca27d45da91f1af",
          "url": "https://github.com/oameye/GraphCombinatorics.jl/commit/d9ae3f3ee7d6c757aa3947a25b60a0eb0dafd768"
        },
        "date": 1746194539330,
        "tool": "julia",
        "benches": [
          {
            "name": "Phi^4 theory/3 loops",
            "value": 712929618,
            "unit": "ns",
            "extra": "gctime=114828638\nmemory=1107673856\nallocs=10027936\nparams={\"gctrial\":true,\"time_tolerance\":0.05,\"evals_set\":false,\"samples\":10000,\"evals\":1,\"gcsample\":false,\"seconds\":10,\"overhead\":0,\"memory_tolerance\":0.01}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 1500454,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3824352\nallocs=38593\nparams={\"gctrial\":true,\"time_tolerance\":0.05,\"evals_set\":false,\"samples\":10000,\"evals\":1,\"gcsample\":false,\"seconds\":10,\"overhead\":0,\"memory_tolerance\":0.01}"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "orjan.ameye@hotmail.com",
            "name": "Orjan Ameye",
            "username": "oameye"
          },
          "committer": {
            "email": "noreply@github.com",
            "name": "GitHub",
            "username": "web-flow"
          },
          "distinct": true,
          "id": "9a167d3220baa5252f0b6a702e836e9ad448ffcc",
          "message": "refactor: replace propagator usage with edges (#7)",
          "timestamp": "2025-05-02T17:44:21+02:00",
          "tree_id": "318e1f765ea0bcb566af788606b046c6abddd206",
          "url": "https://github.com/oameye/GraphCombinatorics.jl/commit/9a167d3220baa5252f0b6a702e836e9ad448ffcc"
        },
        "date": 1746200743478,
        "tool": "julia",
        "benches": [
          {
            "name": "Phi^4 theory/3 loops",
            "value": 729206927.5,
            "unit": "ns",
            "extra": "gctime=120808181\nmemory=1107673856\nallocs=10027936\nparams={\"gctrial\":true,\"time_tolerance\":0.05,\"evals_set\":false,\"samples\":10000,\"evals\":1,\"gcsample\":false,\"seconds\":10,\"overhead\":0,\"memory_tolerance\":0.01}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 1514096,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3824352\nallocs=38593\nparams={\"gctrial\":true,\"time_tolerance\":0.05,\"evals_set\":false,\"samples\":10000,\"evals\":1,\"gcsample\":false,\"seconds\":10,\"overhead\":0,\"memory_tolerance\":0.01}"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "orjan.ameye@hotmail.com",
            "name": "Orjan Ameye",
            "username": "oameye"
          },
          "committer": {
            "email": "noreply@github.com",
            "name": "GitHub",
            "username": "web-flow"
          },
          "distinct": true,
          "id": "057e30895cdbebc2b56c7f084432452d054e84e5",
          "message": "docs: add MultigraphWrap docstring (#9)",
          "timestamp": "2025-05-02T17:51:48+02:00",
          "tree_id": "242c5aa9358d13a2a599ae58c533aa99e8a98a06",
          "url": "https://github.com/oameye/GraphCombinatorics.jl/commit/057e30895cdbebc2b56c7f084432452d054e84e5"
        },
        "date": 1746201184891,
        "tool": "julia",
        "benches": [
          {
            "name": "Phi^4 theory/3 loops",
            "value": 738414703,
            "unit": "ns",
            "extra": "gctime=120592614\nmemory=1107673856\nallocs=10027936\nparams={\"gctrial\":true,\"time_tolerance\":0.05,\"evals_set\":false,\"samples\":10000,\"evals\":1,\"gcsample\":false,\"seconds\":10,\"overhead\":0,\"memory_tolerance\":0.01}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 1516231,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3824352\nallocs=38593\nparams={\"gctrial\":true,\"time_tolerance\":0.05,\"evals_set\":false,\"samples\":10000,\"evals\":1,\"gcsample\":false,\"seconds\":10,\"overhead\":0,\"memory_tolerance\":0.01}"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "orjan.ameye@hotmail.com",
            "name": "Orjan Ameye",
            "username": "oameye"
          },
          "committer": {
            "email": "noreply@github.com",
            "name": "GitHub",
            "username": "web-flow"
          },
          "distinct": true,
          "id": "f418323a8d33b954b373e2b90a186c4987584761",
          "message": "refactor: filter_graphs (#10)",
          "timestamp": "2025-05-02T18:15:27+02:00",
          "tree_id": "bb6ef4c72cdbede3ffe6008a31d339c400379ef8",
          "url": "https://github.com/oameye/GraphCombinatorics.jl/commit/f418323a8d33b954b373e2b90a186c4987584761"
        },
        "date": 1746202606825,
        "tool": "julia",
        "benches": [
          {
            "name": "Phi^4 theory/3 loops",
            "value": 737293195.5,
            "unit": "ns",
            "extra": "gctime=119378424\nmemory=1107673856\nallocs=10027936\nparams={\"gctrial\":true,\"time_tolerance\":0.05,\"evals_set\":false,\"samples\":10000,\"evals\":1,\"gcsample\":false,\"seconds\":10,\"overhead\":0,\"memory_tolerance\":0.01}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 1490546.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3824352\nallocs=38593\nparams={\"gctrial\":true,\"time_tolerance\":0.05,\"evals_set\":false,\"samples\":10000,\"evals\":1,\"gcsample\":false,\"seconds\":10,\"overhead\":0,\"memory_tolerance\":0.01}"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "orjan.ameye@hotmail.com",
            "name": "Orjan Ameye",
            "username": "oameye"
          },
          "committer": {
            "email": "noreply@github.com",
            "name": "GitHub",
            "username": "web-flow"
          },
          "distinct": true,
          "id": "92e9c2b17470ca2a22558f61eb827d8055a657a2",
          "message": "refactor: allgraphs (#12)",
          "timestamp": "2025-05-02T18:32:38+02:00",
          "tree_id": "6eb2c0d8637892ec1f34e6ab8eab1ed8a598effb",
          "url": "https://github.com/oameye/GraphCombinatorics.jl/commit/92e9c2b17470ca2a22558f61eb827d8055a657a2"
        },
        "date": 1746203637152,
        "tool": "julia",
        "benches": [
          {
            "name": "Phi^4 theory/3 loops",
            "value": 740897140,
            "unit": "ns",
            "extra": "gctime=114558776\nmemory=1107673856\nallocs=10027936\nparams={\"gctrial\":true,\"time_tolerance\":0.05,\"evals_set\":false,\"samples\":10000,\"evals\":1,\"gcsample\":false,\"seconds\":10,\"overhead\":0,\"memory_tolerance\":0.01}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 1497937,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3824352\nallocs=38593\nparams={\"gctrial\":true,\"time_tolerance\":0.05,\"evals_set\":false,\"samples\":10000,\"evals\":1,\"gcsample\":false,\"seconds\":10,\"overhead\":0,\"memory_tolerance\":0.01}"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "orjan.ameye@hotmail.com",
            "name": "Orjan Ameye",
            "username": "oameye"
          },
          "committer": {
            "email": "noreply@github.com",
            "name": "GitHub",
            "username": "web-flow"
          },
          "distinct": true,
          "id": "a38b3843dc91be6b33a7e47cf0d8bd468d41e236",
          "message": "docs: define API (#13)",
          "timestamp": "2025-05-02T19:10:15+02:00",
          "tree_id": "52de76e165886b6f67b084373818e96637d9bc02",
          "url": "https://github.com/oameye/GraphCombinatorics.jl/commit/a38b3843dc91be6b33a7e47cf0d8bd468d41e236"
        },
        "date": 1746205899350,
        "tool": "julia",
        "benches": [
          {
            "name": "Phi^4 theory/3 loops",
            "value": 744279045,
            "unit": "ns",
            "extra": "gctime=125115085\nmemory=1107673856\nallocs=10027936\nparams={\"gctrial\":true,\"time_tolerance\":0.05,\"evals_set\":false,\"samples\":10000,\"evals\":1,\"gcsample\":false,\"seconds\":10,\"overhead\":0,\"memory_tolerance\":0.01}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 1553148,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3824352\nallocs=38593\nparams={\"gctrial\":true,\"time_tolerance\":0.05,\"evals_set\":false,\"samples\":10000,\"evals\":1,\"gcsample\":false,\"seconds\":10,\"overhead\":0,\"memory_tolerance\":0.01}"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "orjan.ameye@hotmail.com",
            "name": "Orjan Ameye",
            "username": "oameye"
          },
          "committer": {
            "email": "noreply@github.com",
            "name": "GitHub",
            "username": "web-flow"
          },
          "distinct": true,
          "id": "d3009ba992ec088918d4de5a2def6b04bb329be4",
          "message": "docs: add some jldoctest's (#14)",
          "timestamp": "2025-05-02T19:41:12+02:00",
          "tree_id": "1823b920ff9b1f0741af859b1c7dbb31fe4df07e",
          "url": "https://github.com/oameye/GraphCombinatorics.jl/commit/d3009ba992ec088918d4de5a2def6b04bb329be4"
        },
        "date": 1746207750928,
        "tool": "julia",
        "benches": [
          {
            "name": "Phi^4 theory/3 loops",
            "value": 750754490.5,
            "unit": "ns",
            "extra": "gctime=127704259\nmemory=1107673856\nallocs=10027936\nparams={\"gctrial\":true,\"time_tolerance\":0.05,\"evals_set\":false,\"samples\":10000,\"evals\":1,\"gcsample\":false,\"seconds\":10,\"overhead\":0,\"memory_tolerance\":0.01}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 1538253,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3824352\nallocs=38593\nparams={\"gctrial\":true,\"time_tolerance\":0.05,\"evals_set\":false,\"samples\":10000,\"evals\":1,\"gcsample\":false,\"seconds\":10,\"overhead\":0,\"memory_tolerance\":0.01}"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "orjan.ameye@hotmail.com",
            "name": "Orjan Ameye",
            "username": "oameye"
          },
          "committer": {
            "email": "noreply@github.com",
            "name": "GitHub",
            "username": "web-flow"
          },
          "distinct": true,
          "id": "1f4535b967adba93aeffa2ad497011e3ddd24360",
          "message": "feat: disconnected graphs (#15)",
          "timestamp": "2025-05-02T20:17:46+02:00",
          "tree_id": "c62976172bb60d24a8f04d0adadb22b770a40988",
          "url": "https://github.com/oameye/GraphCombinatorics.jl/commit/1f4535b967adba93aeffa2ad497011e3ddd24360"
        },
        "date": 1746209944109,
        "tool": "julia",
        "benches": [
          {
            "name": "Phi^4 theory/3 loops",
            "value": 701240955,
            "unit": "ns",
            "extra": "gctime=111676894\nmemory=1107673856\nallocs=10027936\nparams={\"gctrial\":true,\"time_tolerance\":0.05,\"evals_set\":false,\"samples\":10000,\"evals\":1,\"gcsample\":false,\"seconds\":10,\"overhead\":0,\"memory_tolerance\":0.01}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 1535680,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3824352\nallocs=38593\nparams={\"gctrial\":true,\"time_tolerance\":0.05,\"evals_set\":false,\"samples\":10000,\"evals\":1,\"gcsample\":false,\"seconds\":10,\"overhead\":0,\"memory_tolerance\":0.01}"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "orjan.ameye@hotmail.com",
            "name": "Orjan Ameye",
            "username": "oameye"
          },
          "committer": {
            "email": "noreply@github.com",
            "name": "GitHub",
            "username": "web-flow"
          },
          "distinct": true,
          "id": "2cee77f186c3d257c8316b74b05e5103199b5409",
          "message": "refactor: rename the package to GraphCombinations (#16)",
          "timestamp": "2025-05-02T20:43:16+02:00",
          "tree_id": "13f857467e6c4920eca720ab9fb1ab15915e0cc4",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/2cee77f186c3d257c8316b74b05e5103199b5409"
        },
        "date": 1746211473383,
        "tool": "julia",
        "benches": [
          {
            "name": "Phi^4 theory/3 loops",
            "value": 740543052,
            "unit": "ns",
            "extra": "gctime=120617792.5\nmemory=1107673856\nallocs=10027936\nparams={\"gctrial\":true,\"time_tolerance\":0.05,\"evals_set\":false,\"samples\":10000,\"evals\":1,\"gcsample\":false,\"seconds\":10,\"overhead\":0,\"memory_tolerance\":0.01}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 1535479,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3824352\nallocs=38593\nparams={\"gctrial\":true,\"time_tolerance\":0.05,\"evals_set\":false,\"samples\":10000,\"evals\":1,\"gcsample\":false,\"seconds\":10,\"overhead\":0,\"memory_tolerance\":0.01}"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "orjan.ameye@hotmail.com",
            "name": "Orjan Ameye",
            "username": "oameye"
          },
          "committer": {
            "email": "noreply@github.com",
            "name": "GitHub",
            "username": "web-flow"
          },
          "distinct": true,
          "id": "3efa08816bec85673dde1c6ed23a0d305f29ce46",
          "message": "docs: update examples (#18)",
          "timestamp": "2025-05-02T20:57:11+02:00",
          "tree_id": "7d26cdca2376b4800d715e9ae9a6103b934448d6",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/3efa08816bec85673dde1c6ed23a0d305f29ce46"
        },
        "date": 1746212314037,
        "tool": "julia",
        "benches": [
          {
            "name": "Phi^4 theory/3 loops",
            "value": 751325357.5,
            "unit": "ns",
            "extra": "gctime=126615497.5\nmemory=1107673856\nallocs=10027936\nparams={\"gctrial\":true,\"time_tolerance\":0.05,\"evals_set\":false,\"samples\":10000,\"evals\":1,\"gcsample\":false,\"seconds\":10,\"overhead\":0,\"memory_tolerance\":0.01}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 1569167.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3824352\nallocs=38593\nparams={\"gctrial\":true,\"time_tolerance\":0.05,\"evals_set\":false,\"samples\":10000,\"evals\":1,\"gcsample\":false,\"seconds\":10,\"overhead\":0,\"memory_tolerance\":0.01}"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "orjan.ameye@hotmail.com",
            "name": "Orjan Ameye",
            "username": "oameye"
          },
          "committer": {
            "email": "noreply@github.com",
            "name": "GitHub",
            "username": "web-flow"
          },
          "distinct": true,
          "id": "33e2ca5d0c1f0328ee7a2cfa6f121fecddb6fd35",
          "message": "buid: tag 0.1.0 version (#19)",
          "timestamp": "2025-05-02T21:07:38+02:00",
          "tree_id": "4cdc244a621ac4660be84381269a9f1a89005fae",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/33e2ca5d0c1f0328ee7a2cfa6f121fecddb6fd35"
        },
        "date": 1746212935429,
        "tool": "julia",
        "benches": [
          {
            "name": "Phi^4 theory/3 loops",
            "value": 737669499,
            "unit": "ns",
            "extra": "gctime=123478587\nmemory=1107673856\nallocs=10027936\nparams={\"gctrial\":true,\"time_tolerance\":0.05,\"evals_set\":false,\"samples\":10000,\"evals\":1,\"gcsample\":false,\"seconds\":10,\"overhead\":0,\"memory_tolerance\":0.01}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 1532633,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3824352\nallocs=38593\nparams={\"gctrial\":true,\"time_tolerance\":0.05,\"evals_set\":false,\"samples\":10000,\"evals\":1,\"gcsample\":false,\"seconds\":10,\"overhead\":0,\"memory_tolerance\":0.01}"
          }
        ]
      }
    ]
  }
}