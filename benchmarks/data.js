window.BENCHMARK_DATA = {
  "lastUpdate": 1789583643831,
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
      },
      {
        "commit": {
          "author": {
            "email": "49699333+dependabot[bot]@users.noreply.github.com",
            "name": "dependabot[bot]",
            "username": "dependabot[bot]"
          },
          "committer": {
            "email": "noreply@github.com",
            "name": "GitHub",
            "username": "web-flow"
          },
          "distinct": true,
          "id": "cf5e32f6301be1423ede63d2ddbb2fc718f2493c",
          "message": "build(deps): bump julia-actions/cache from 2 to 3 (#48)\n\nCo-authored-by: dependabot[bot] <49699333+dependabot[bot]@users.noreply.github.com>",
          "timestamp": "2026-03-12T08:26:08+01:00",
          "tree_id": "061365ab2ae0da7a7193d40afc93b97f4005c6d1",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/cf5e32f6301be1423ede63d2ddbb2fc718f2493c"
        },
        "date": 1773300460786,
        "tool": "julia",
        "benches": [
          {
            "name": "Phi^4 theory/3 loops",
            "value": 689418774,
            "unit": "ns",
            "extra": "gctime=91749732\nmemory=1216383200\nallocs=11720485\nparams={\"gctrial\":true,\"time_tolerance\":0.05,\"evals_set\":false,\"samples\":10000,\"evals\":1,\"gcsample\":false,\"seconds\":10,\"overhead\":0,\"memory_tolerance\":0.01}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 1714463.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3991824\nallocs=42955\nparams={\"gctrial\":true,\"time_tolerance\":0.05,\"evals_set\":false,\"samples\":10000,\"evals\":1,\"gcsample\":false,\"seconds\":10,\"overhead\":0,\"memory_tolerance\":0.01}"
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
          "id": "c1d24e59fbceef225a497946117ca30ee5fa69b3",
          "message": "Update test matrix versions in Tests.yml (#49)",
          "timestamp": "2026-03-12T08:32:28+01:00",
          "tree_id": "08c34432aa6ad4096ea9857c85bf0d3449879646",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/c1d24e59fbceef225a497946117ca30ee5fa69b3"
        },
        "date": 1773300824849,
        "tool": "julia",
        "benches": [
          {
            "name": "Phi^4 theory/3 loops",
            "value": 696174593,
            "unit": "ns",
            "extra": "gctime=94208287\nmemory=1216383200\nallocs=11720485\nparams={\"gctrial\":true,\"time_tolerance\":0.05,\"evals_set\":false,\"samples\":10000,\"evals\":1,\"gcsample\":false,\"seconds\":10,\"overhead\":0,\"memory_tolerance\":0.01}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 1741162,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3991824\nallocs=42955\nparams={\"gctrial\":true,\"time_tolerance\":0.05,\"evals_set\":false,\"samples\":10000,\"evals\":1,\"gcsample\":false,\"seconds\":10,\"overhead\":0,\"memory_tolerance\":0.01}"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "49699333+dependabot[bot]@users.noreply.github.com",
            "name": "dependabot[bot]",
            "username": "dependabot[bot]"
          },
          "committer": {
            "email": "noreply@github.com",
            "name": "GitHub",
            "username": "web-flow"
          },
          "distinct": true,
          "id": "8bba03d6b99c7b2929d22d76dcbcbc0e9da4177e",
          "message": "build(deps): bump codecov/codecov-action from 5 to 6 (#50)\n\nCo-authored-by: dependabot[bot] <49699333+dependabot[bot]@users.noreply.github.com>",
          "timestamp": "2026-04-02T10:12:46+02:00",
          "tree_id": "ada2a8af0919e99a3ed98eac3083bbec06175b61",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/8bba03d6b99c7b2929d22d76dcbcbc0e9da4177e"
        },
        "date": 1775117665390,
        "tool": "julia",
        "benches": [
          {
            "name": "Phi^4 theory/2 loops",
            "value": 1768414,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3991824\nallocs=42955\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 730873506.5,
            "unit": "ns",
            "extra": "gctime=110540320.5\nmemory=1216383200\nallocs=11720485\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "49699333+dependabot[bot]@users.noreply.github.com",
            "name": "dependabot[bot]",
            "username": "dependabot[bot]"
          },
          "committer": {
            "email": "noreply@github.com",
            "name": "GitHub",
            "username": "web-flow"
          },
          "distinct": true,
          "id": "1fe78ea04f19549ba9ddf6c5298acee720a13a52",
          "message": "build(deps): bump actions/checkout from 4 to 6 (#52)\n\nCo-authored-by: dependabot[bot] <49699333+dependabot[bot]@users.noreply.github.com>",
          "timestamp": "2026-04-09T08:57:50+02:00",
          "tree_id": "c8c07573030399677d2321b68cac534492edb3a6",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/1fe78ea04f19549ba9ddf6c5298acee720a13a52"
        },
        "date": 1775717966886,
        "tool": "julia",
        "benches": [
          {
            "name": "Phi^4 theory/2 loops",
            "value": 1769108.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3991824\nallocs=42955\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 724035286,
            "unit": "ns",
            "extra": "gctime=148070875.5\nmemory=1216383200\nallocs=11720485\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "49699333+dependabot[bot]@users.noreply.github.com",
            "name": "dependabot[bot]",
            "username": "dependabot[bot]"
          },
          "committer": {
            "email": "noreply@github.com",
            "name": "GitHub",
            "username": "web-flow"
          },
          "distinct": true,
          "id": "7a7fc481a1a46f697d14a8e7a7025cd56675bf95",
          "message": "build(deps): bump julia-actions/setup-julia from 2 to 3 (#54)\n\nCo-authored-by: dependabot[bot] <49699333+dependabot[bot]@users.noreply.github.com>",
          "timestamp": "2026-04-23T10:43:39+02:00",
          "tree_id": "3de0e1f72a3999461f24eb0240e684a938fb8e7b",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/7a7fc481a1a46f697d14a8e7a7025cd56675bf95"
        },
        "date": 1776933920242,
        "tool": "julia",
        "benches": [
          {
            "name": "Phi^4 theory/2 loops",
            "value": 1741566,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3991824\nallocs=42955\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 743475782,
            "unit": "ns",
            "extra": "gctime=110962746.5\nmemory=1216383200\nallocs=11720485\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "49699333+dependabot[bot]@users.noreply.github.com",
            "name": "dependabot[bot]",
            "username": "dependabot[bot]"
          },
          "committer": {
            "email": "noreply@github.com",
            "name": "GitHub",
            "username": "web-flow"
          },
          "distinct": true,
          "id": "349bdde37353cdff7ddc96d809a8d1c3afb6de1c",
          "message": "build(deps): bump codecov/codecov-action from 6 to 7 (#61)\n\nBumps [codecov/codecov-action](https://github.com/codecov/codecov-action) from 6 to 7.\n- [Release notes](https://github.com/codecov/codecov-action/releases)\n- [Changelog](https://github.com/codecov/codecov-action/blob/main/CHANGELOG.md)\n- [Commits](https://github.com/codecov/codecov-action/compare/v6...v7)\n\n---\nupdated-dependencies:\n- dependency-name: codecov/codecov-action\n  dependency-version: '7'\n  dependency-type: direct:production\n  update-type: version-update:semver-major\n...\n\nSigned-off-by: dependabot[bot] <support@github.com>\nCo-authored-by: dependabot[bot] <49699333+dependabot[bot]@users.noreply.github.com>",
          "timestamp": "2026-06-11T09:30:43+02:00",
          "tree_id": "455d663b5d26dedb2d3e9401ccd8c754e9be4fb7",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/349bdde37353cdff7ddc96d809a8d1c3afb6de1c"
        },
        "date": 1781163138599,
        "tool": "julia",
        "benches": [
          {
            "name": "Phi^4 theory/2 loops",
            "value": 1768028,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3991824\nallocs=42955\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 760851190,
            "unit": "ns",
            "extra": "gctime=119825368.5\nmemory=1216383200\nallocs=11720485\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          }
        ]
      },
      {
        "commit": {
          "author": {
            "email": "49699333+dependabot[bot]@users.noreply.github.com",
            "name": "dependabot[bot]",
            "username": "dependabot[bot]"
          },
          "committer": {
            "email": "noreply@github.com",
            "name": "GitHub",
            "username": "web-flow"
          },
          "distinct": true,
          "id": "3b162a90fac45d57b63094908ef1a0ebc724652b",
          "message": "build(deps): bump actions/checkout from 6 to 7 (#62)\n\nBumps [actions/checkout](https://github.com/actions/checkout) from 6 to 7.\n- [Release notes](https://github.com/actions/checkout/releases)\n- [Changelog](https://github.com/actions/checkout/blob/main/CHANGELOG.md)\n- [Commits](https://github.com/actions/checkout/compare/v6...v7)\n\n---\nupdated-dependencies:\n- dependency-name: actions/checkout\n  dependency-version: '7'\n  dependency-type: direct:production\n  update-type: version-update:semver-major\n...\n\nSigned-off-by: dependabot[bot] <support@github.com>\nCo-authored-by: dependabot[bot] <49699333+dependabot[bot]@users.noreply.github.com>",
          "timestamp": "2026-06-25T09:09:10+02:00",
          "tree_id": "b091f3ec3851baa7848856b2957929482562e2cb",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/3b162a90fac45d57b63094908ef1a0ebc724652b"
        },
        "date": 1782371442522,
        "tool": "julia",
        "benches": [
          {
            "name": "Phi^4 theory/2 loops",
            "value": 1799221,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3991824\nallocs=42955\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 752347868.5,
            "unit": "ns",
            "extra": "gctime=117864390\nmemory=1216383200\nallocs=11720485\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
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
          "id": "cad0aaf0b952ff665769d0306613cc8725320f2a",
          "message": "ci: certify Julia 1.13 support (#67)\n\n* ci: test Julia 1.13 explicitly\n\n* test: make graph enumeration order-independent\n\n* style: apply current JuliaFormatter\n\n* style: apply current JuliaFormatter\n\n* style: apply current JuliaFormatter\n\n* style: format Julia 1.13 compatibility test\n\n* test: avoid topology enumeration order assumption\n\n* docs: make graph topology doctest order-independent\n\n* compat: allow JET on Julia 1.13\n\n* test: restore JET linting on modern Julia\n\n* test: use JET 0.12 API on modern Julia",
          "timestamp": "2026-09-10T14:45:05+02:00",
          "tree_id": "925ff735dfe39ed1362522ae92573f45e298512f",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/cad0aaf0b952ff665769d0306613cc8725320f2a"
        },
        "date": 1789045011222,
        "tool": "julia",
        "benches": [
          {
            "name": "Phi^4 theory/2 loops",
            "value": 1765489,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3991824\nallocs=42955\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 795717693,
            "unit": "ns",
            "extra": "gctime=135838539\nmemory=1216383200\nallocs=11720485\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
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
          "id": "e82cecd9bfb590853d6a124bfaefe6a5efc9f53a",
          "message": "ci: restore moving Julia 1 selector (#68)",
          "timestamp": "2026-09-10T15:13:12+02:00",
          "tree_id": "78b49be5eb136c99b9a4fa8a21c53895c64343b5",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/e82cecd9bfb590853d6a124bfaefe6a5efc9f53a"
        },
        "date": 1789047440931,
        "tool": "julia",
        "benches": [
          {
            "name": "Phi^4 theory/2 loops",
            "value": 1474133,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3991824\nallocs=42955\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 719621163.5,
            "unit": "ns",
            "extra": "gctime=141793224.5\nmemory=1216383200\nallocs=11720485\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
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
          "id": "365dbcd20dcd7c5483f4a5dca7624ea0417f40f2",
          "message": "fix: tighten graph-generation API contracts (#69)\n\n* fix: tighten graph-generation API contracts\n\n* fix: validate graph construction and preserve loops\n\n* test: cover graph-construction edge cases\n\n* style: apply JuliaFormatter",
          "timestamp": "2026-09-10T19:28:24+02:00",
          "tree_id": "33d56534b5c187e1736f3bd5443fea3b91882be6",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/365dbcd20dcd7c5483f4a5dca7624ea0417f40f2"
        },
        "date": 1789061382996,
        "tool": "julia",
        "benches": [
          {
            "name": "Phi^4 theory/2 loops",
            "value": 1847535,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3991920\nallocs=42956\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 870603744.5,
            "unit": "ns",
            "extra": "gctime=159171437\nmemory=1216383296\nallocs=11720486\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
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
          "id": "cf89dcdc8b02b6728f7d60d75ecba57db3800d69",
          "message": "fix: compute symmetry factors exactly (#71)",
          "timestamp": "2026-09-10T19:29:56+02:00",
          "tree_id": "88f196305e00db2ab35892bac0d7396de7c40812",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/cf89dcdc8b02b6728f7d60d75ecba57db3800d69"
        },
        "date": 1789061475540,
        "tool": "julia",
        "benches": [
          {
            "name": "Phi^4 theory/2 loops",
            "value": 1815025,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3993184\nallocs=43030\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 800397497,
            "unit": "ns",
            "extra": "gctime=129607940\nmemory=1216385424\nallocs=11720602\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
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
          "id": "019af5b071223c77047020cc9dd206b0e098913f",
          "message": "test: add Wick reference oracle and pipeline benchmarks (#72)",
          "timestamp": "2026-09-10T19:30:46+02:00",
          "tree_id": "bea191a3871f8d7f9154224df593715e07608164",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/019af5b071223c77047020cc9dd206b0e098913f"
        },
        "date": 1789061630749,
        "tool": "julia",
        "benches": [
          {
            "name": "Phi^4 theory/2 loops",
            "value": 1818931,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3993184\nallocs=43030\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 809650824,
            "unit": "ns",
            "extra": "gctime=173487267\nmemory=1216385424\nallocs=11720602\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cached",
            "value": 240,
            "unit": "ns",
            "extra": "gctime=0\nmemory=192\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cold",
            "value": 105305.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=336528\nallocs=3021\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/allgraphs cold",
            "value": 1965269.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=4329520\nallocs=46047\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/canonical form",
            "value": 1570,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3744\nallocs=38\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/connected filter",
            "value": 483609.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1114752\nallocs=13755\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/isomorphism reduction",
            "value": 1302768.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2876032\nallocs=29189\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
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
          "id": "ab8dd1df928a584c8a33a727e00b1583375a566d",
          "message": "perf: add direct multigraph generator (#74)",
          "timestamp": "2026-09-10T19:31:24+02:00",
          "tree_id": "88fc1ffe7c60e0281a051a6b911b8693fe6fdad6",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/ab8dd1df928a584c8a33a727e00b1583375a566d"
        },
        "date": 1789061743825,
        "tool": "julia",
        "benches": [
          {
            "name": "Direct/allgraphs - 2 loops",
            "value": 21632,
            "unit": "ns",
            "extra": "gctime=0\nmemory=40520\nallocs=567\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 3 loops",
            "value": 312140,
            "unit": "ns",
            "extra": "gctime=0\nmemory=626904\nallocs=6687\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 4 loops",
            "value": 14724072.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=29628664\nallocs=253583\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 5 loops",
            "value": 1746023986.5,
            "unit": "ns",
            "extra": "gctime=191825292\nmemory=3503457208\nallocs=25610206\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 2 loops",
            "value": 1467.2,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2336\nallocs=21\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 3 loops",
            "value": 11627,
            "unit": "ns",
            "extra": "gctime=0\nmemory=17648\nallocs=106\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 4 loops",
            "value": 163871,
            "unit": "ns",
            "extra": "gctime=0\nmemory=277264\nallocs=1337\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 5 loops",
            "value": 4626736,
            "unit": "ns",
            "extra": "gctime=0\nmemory=6349696\nallocs=26462\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 1780561.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3993184\nallocs=43030\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 844637050,
            "unit": "ns",
            "extra": "gctime=153802070\nmemory=1216385424\nallocs=11720602\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cached",
            "value": 231,
            "unit": "ns",
            "extra": "gctime=0\nmemory=192\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cold",
            "value": 110386.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=336528\nallocs=3021\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/allgraphs cold",
            "value": 1903896.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=4329520\nallocs=46047\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/canonical form",
            "value": 1525.3,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3744\nallocs=38\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/connected filter",
            "value": 494715,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1114752\nallocs=13755\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/isomorphism reduction",
            "value": 1249105,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2876032\nallocs=29189\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
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
          "id": "15cae16ccc48c7a7fba4edce8a45d5011fc1fd27",
          "message": "perf: switch allgraphs to direct generation (#76)",
          "timestamp": "2026-09-10T19:32:08+02:00",
          "tree_id": "4ff1db24b683671fa1ed335ce625d812e803d3ca",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/15cae16ccc48c7a7fba4edce8a45d5011fc1fd27"
        },
        "date": 1789061759401,
        "tool": "julia",
        "benches": [
          {
            "name": "Direct/allgraphs - 2 loops",
            "value": 22384,
            "unit": "ns",
            "extra": "gctime=0\nmemory=40520\nallocs=567\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 3 loops",
            "value": 328195,
            "unit": "ns",
            "extra": "gctime=0\nmemory=626904\nallocs=6687\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 4 loops",
            "value": 14998440,
            "unit": "ns",
            "extra": "gctime=0\nmemory=29628664\nallocs=253583\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 5 loops",
            "value": 1829672485,
            "unit": "ns",
            "extra": "gctime=209721176\nmemory=3503457208\nallocs=25610206\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 2 loops",
            "value": 1496.2,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2336\nallocs=21\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 3 loops",
            "value": 12169,
            "unit": "ns",
            "extra": "gctime=0\nmemory=17648\nallocs=106\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 4 loops",
            "value": 167052,
            "unit": "ns",
            "extra": "gctime=0\nmemory=277264\nallocs=1337\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 5 loops",
            "value": 4949938.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=6349696\nallocs=26462\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 22254,
            "unit": "ns",
            "extra": "gctime=0\nmemory=40616\nallocs=568\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 327103.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=627000\nallocs=6688\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cached",
            "value": 240,
            "unit": "ns",
            "extra": "gctime=0\nmemory=192\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cold",
            "value": 115174,
            "unit": "ns",
            "extra": "gctime=0\nmemory=336528\nallocs=3021\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/allgraphs production",
            "value": 22474,
            "unit": "ns",
            "extra": "gctime=0\nmemory=40616\nallocs=568\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/canonical form",
            "value": 1581.4,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3744\nallocs=38\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/connected filter",
            "value": 506014,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1114752\nallocs=13755\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/isomorphism reduction",
            "value": 1319382,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2876032\nallocs=29189\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
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
          "id": "122616bdb707f3b39016f8145f0c91e8269915a6",
          "message": "perf: switch to allocation-lean canonicalization (#80)",
          "timestamp": "2026-09-10T19:33:31+02:00",
          "tree_id": "64f2c09676dd9c60b582216073bfaa5571648648",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/122616bdb707f3b39016f8145f0c91e8269915a6"
        },
        "date": 1789061886790,
        "tool": "julia",
        "benches": [
          {
            "name": "Canonical/reference - 2 internal",
            "value": 1586.4,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3744\nallocs=38\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 3 internal",
            "value": 3902.125,
            "unit": "ns",
            "extra": "gctime=0\nmemory=9008\nallocs=83\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 4 internal",
            "value": 14947.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=34352\nallocs=282\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 5 internal",
            "value": 85077,
            "unit": "ns",
            "extra": "gctime=0\nmemory=201296\nallocs=1458\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 2 internal",
            "value": 994.3152173913044,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2224\nallocs=27\nparams={\"evals\":46,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 3 internal",
            "value": 1875.8,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3808\nallocs=48\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 4 internal",
            "value": 6383.6,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11520\nallocs=139\nparams={\"evals\":5,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 5 internal",
            "value": 39189,
            "unit": "ns",
            "extra": "gctime=0\nmemory=78656\nallocs=739\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 2 loops",
            "value": 18107,
            "unit": "ns",
            "extra": "gctime=0\nmemory=31400\nallocs=501\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 3 loops",
            "value": 199758,
            "unit": "ns",
            "extra": "gctime=0\nmemory=346104\nallocs=4797\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 4 loops",
            "value": 7428627,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11271736\nallocs=138611\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 5 loops",
            "value": 864378375,
            "unit": "ns",
            "extra": "gctime=60412089.5\nmemory=1394049208\nallocs=13243406\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 2 loops",
            "value": 1471.2,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2336\nallocs=21\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 3 loops",
            "value": 11747,
            "unit": "ns",
            "extra": "gctime=0\nmemory=17648\nallocs=106\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 4 loops",
            "value": 168097.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=277264\nallocs=1337\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 5 loops",
            "value": 4903424,
            "unit": "ns",
            "extra": "gctime=0\nmemory=6349696\nallocs=26462\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 18168,
            "unit": "ns",
            "extra": "gctime=0\nmemory=31496\nallocs=502\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 197850.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=346200\nallocs=4798\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cached",
            "value": 241,
            "unit": "ns",
            "extra": "gctime=0\nmemory=192\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cold",
            "value": 112272.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=336528\nallocs=3021\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/allgraphs production",
            "value": 18348,
            "unit": "ns",
            "extra": "gctime=0\nmemory=31496\nallocs=502\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/canonical form",
            "value": 1009.2962962962963,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2224\nallocs=27\nparams={\"evals\":27,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/connected filter",
            "value": 499316,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1114752\nallocs=13755\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/isomorphism reduction",
            "value": 851201,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1708672\nallocs=20741\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
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
          "id": "3adbc2ef4bc329f944cca3b67ac72118803d7e87",
          "message": "perf: add allocation-lean canonicalizer candidate (#78)",
          "timestamp": "2026-09-10T19:32:55+02:00",
          "tree_id": "1204c890f6bd3a7f205360686cfeee95392e9194",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/3adbc2ef4bc329f944cca3b67ac72118803d7e87"
        },
        "date": 1789061888767,
        "tool": "julia",
        "benches": [
          {
            "name": "Canonical/reference - 2 internal",
            "value": 1478.7,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3744\nallocs=38\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 3 internal",
            "value": 3653,
            "unit": "ns",
            "extra": "gctime=0\nmemory=9008\nallocs=83\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 4 internal",
            "value": 14396,
            "unit": "ns",
            "extra": "gctime=0\nmemory=34352\nallocs=282\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 5 internal",
            "value": 79804.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=201296\nallocs=1458\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 2 internal",
            "value": 955.6666666666666,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2224\nallocs=27\nparams={\"evals\":54,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 3 internal",
            "value": 1792.3,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3808\nallocs=48\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 4 internal",
            "value": 5972.833333333333,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11520\nallocs=139\nparams={\"evals\":6,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 5 internal",
            "value": 37681,
            "unit": "ns",
            "extra": "gctime=0\nmemory=78656\nallocs=739\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 2 loops",
            "value": 20949,
            "unit": "ns",
            "extra": "gctime=0\nmemory=40520\nallocs=567\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 3 loops",
            "value": 305261.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=626904\nallocs=6687\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 4 loops",
            "value": 14003876,
            "unit": "ns",
            "extra": "gctime=0\nmemory=29628664\nallocs=253583\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 5 loops",
            "value": 1645935494,
            "unit": "ns",
            "extra": "gctime=151641903\nmemory=3503457208\nallocs=25610206\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 2 loops",
            "value": 1377.6,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2336\nallocs=21\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 3 loops",
            "value": 11191,
            "unit": "ns",
            "extra": "gctime=0\nmemory=17648\nallocs=106\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 4 loops",
            "value": 160079,
            "unit": "ns",
            "extra": "gctime=0\nmemory=277264\nallocs=1337\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 5 loops",
            "value": 4460355,
            "unit": "ns",
            "extra": "gctime=0\nmemory=6349696\nallocs=26462\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 21029,
            "unit": "ns",
            "extra": "gctime=0\nmemory=40616\nallocs=568\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 305070.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=627000\nallocs=6688\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cached",
            "value": 230,
            "unit": "ns",
            "extra": "gctime=0\nmemory=192\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cold",
            "value": 101740,
            "unit": "ns",
            "extra": "gctime=0\nmemory=336528\nallocs=3021\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/allgraphs production",
            "value": 20920,
            "unit": "ns",
            "extra": "gctime=0\nmemory=40616\nallocs=568\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/canonical form",
            "value": 1485.8,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3744\nallocs=38\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/connected filter",
            "value": 490558,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1114752\nallocs=13755\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/isomorphism reduction",
            "value": 1232093.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2876032\nallocs=29189\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
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
          "id": "1e9a351ee22926b3bf83294b870fbf56ed8b3774",
          "message": "perf: add in-place canonical permutation candidate (#82)",
          "timestamp": "2026-09-10T19:34:17+02:00",
          "tree_id": "47cbee440d5a143c6f22636aa48265aabb5fa18f",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/1e9a351ee22926b3bf83294b870fbf56ed8b3774"
        },
        "date": 1789062001682,
        "tool": "julia",
        "benches": [
          {
            "name": "Canonical/in-place - 2 internal",
            "value": 201.12795857988166,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":676,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 3 internal",
            "value": 373.84433962264154,
            "unit": "ns",
            "extra": "gctime=0\nmemory=608\nallocs=4\nparams={\"evals\":212,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 4 internal",
            "value": 1638.1,
            "unit": "ns",
            "extra": "gctime=0\nmemory=720\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 5 internal",
            "value": 17052,
            "unit": "ns",
            "extra": "gctime=0\nmemory=29376\nallocs=123\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 2 internal",
            "value": 1529.9,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3744\nallocs=38\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 3 internal",
            "value": 3750.875,
            "unit": "ns",
            "extra": "gctime=0\nmemory=9008\nallocs=83\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 4 internal",
            "value": 14738,
            "unit": "ns",
            "extra": "gctime=0\nmemory=34352\nallocs=282\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 5 internal",
            "value": 84770,
            "unit": "ns",
            "extra": "gctime=0\nmemory=201296\nallocs=1458\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 2 internal",
            "value": 981.8690476190477,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2224\nallocs=27\nparams={\"evals\":42,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 3 internal",
            "value": 1837.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3808\nallocs=48\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 4 internal",
            "value": 6176.666666666667,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11520\nallocs=139\nparams={\"evals\":6,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 5 internal",
            "value": 40667.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=78656\nallocs=739\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 2 loops",
            "value": 17874,
            "unit": "ns",
            "extra": "gctime=0\nmemory=31400\nallocs=501\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 3 loops",
            "value": 199798,
            "unit": "ns",
            "extra": "gctime=0\nmemory=346104\nallocs=4797\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 4 loops",
            "value": 7032818,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11271736\nallocs=138611\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 5 loops",
            "value": 830061114,
            "unit": "ns",
            "extra": "gctime=53303957\nmemory=1394049208\nallocs=13243406\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 2 loops",
            "value": 1413.7,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2336\nallocs=21\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 3 loops",
            "value": 11391.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=17648\nallocs=106\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 4 loops",
            "value": 164381,
            "unit": "ns",
            "extra": "gctime=0\nmemory=277264\nallocs=1337\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 5 loops",
            "value": 4637773,
            "unit": "ns",
            "extra": "gctime=0\nmemory=6349696\nallocs=26462\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 17943,
            "unit": "ns",
            "extra": "gctime=0\nmemory=31496\nallocs=502\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 200815,
            "unit": "ns",
            "extra": "gctime=0\nmemory=346200\nallocs=4798\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cached",
            "value": 230,
            "unit": "ns",
            "extra": "gctime=0\nmemory=192\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cold",
            "value": 105873.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=336528\nallocs=3021\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/allgraphs production",
            "value": 17924,
            "unit": "ns",
            "extra": "gctime=0\nmemory=31496\nallocs=502\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/canonical form",
            "value": 985.8666666666667,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2224\nallocs=27\nparams={\"evals\":30,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/connected filter",
            "value": 494979,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1114752\nallocs=13755\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/isomorphism reduction",
            "value": 849514.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1708672\nallocs=20741\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
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
          "id": "92d77f83163fed71a202a0052c94ae8400b8fe95",
          "message": "perf: switch to in-place canonical permutations (#84)",
          "timestamp": "2026-09-10T19:35:02+02:00",
          "tree_id": "0daa75d418f4ef579c7b94495a2f3da9f47ed5d6",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/92d77f83163fed71a202a0052c94ae8400b8fe95"
        },
        "date": 1789062015741,
        "tool": "julia",
        "benches": [
          {
            "name": "Canonical/in-place - 2 internal",
            "value": 195.02877697841726,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":695,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 3 internal",
            "value": 360.2079439252336,
            "unit": "ns",
            "extra": "gctime=0\nmemory=608\nallocs=4\nparams={\"evals\":214,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 4 internal",
            "value": 1532.9,
            "unit": "ns",
            "extra": "gctime=0\nmemory=720\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 5 internal",
            "value": 17498,
            "unit": "ns",
            "extra": "gctime=0\nmemory=29376\nallocs=123\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 2 internal",
            "value": 1497.9,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3744\nallocs=38\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 3 internal",
            "value": 3763.25,
            "unit": "ns",
            "extra": "gctime=0\nmemory=9008\nallocs=83\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 4 internal",
            "value": 14067,
            "unit": "ns",
            "extra": "gctime=0\nmemory=34352\nallocs=282\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 5 internal",
            "value": 82776,
            "unit": "ns",
            "extra": "gctime=0\nmemory=201296\nallocs=1458\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 2 internal",
            "value": 969.65625,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2224\nallocs=27\nparams={\"evals\":32,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 3 internal",
            "value": 1824.4,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3808\nallocs=48\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 4 internal",
            "value": 5801,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11520\nallocs=139\nparams={\"evals\":6,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 5 internal",
            "value": 38372,
            "unit": "ns",
            "extra": "gctime=0\nmemory=78656\nallocs=739\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 2 loops",
            "value": 12394,
            "unit": "ns",
            "extra": "gctime=0\nmemory=21128\nallocs=363\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 3 loops",
            "value": 109897,
            "unit": "ns",
            "extra": "gctime=0\nmemory=173304\nallocs=2421\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 4 loops",
            "value": 3059904,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2588536\nallocs=30071\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 5 loops",
            "value": 387227241,
            "unit": "ns",
            "extra": "gctime=15935683\nmemory=546433208\nallocs=2648206\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 2 loops",
            "value": 1397.7,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2336\nallocs=21\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 3 loops",
            "value": 10931,
            "unit": "ns",
            "extra": "gctime=0\nmemory=17648\nallocs=106\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 4 loops",
            "value": 161038,
            "unit": "ns",
            "extra": "gctime=0\nmemory=277264\nallocs=1337\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 5 loops",
            "value": 4371932.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=6349696\nallocs=26462\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 12543,
            "unit": "ns",
            "extra": "gctime=0\nmemory=21224\nallocs=364\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 110107,
            "unit": "ns",
            "extra": "gctime=0\nmemory=173400\nallocs=2422\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cached",
            "value": 231,
            "unit": "ns",
            "extra": "gctime=0\nmemory=192\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cold",
            "value": 100810,
            "unit": "ns",
            "extra": "gctime=0\nmemory=336528\nallocs=3021\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/allgraphs production",
            "value": 12453,
            "unit": "ns",
            "extra": "gctime=0\nmemory=21224\nallocs=364\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/canonical form",
            "value": 197.4791366906475,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":695,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/connected filter",
            "value": 479973,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1114752\nallocs=13755\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/isomorphism reduction",
            "value": 209775,
            "unit": "ns",
            "extra": "gctime=0\nmemory=393856\nallocs=3077\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
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
          "id": "aa9be3a31abfbc1adbb9d84c99b856400f21f99d",
          "message": "feat: return automorphism order from canonicalization (#93)",
          "timestamp": "2026-09-11T08:03:04+02:00",
          "tree_id": "98dc0b2f5005aba0ea82f52665025fb44c9077c5",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/aa9be3a31abfbc1adbb9d84c99b856400f21f99d"
        },
        "date": 1789106905891,
        "tool": "julia",
        "benches": [
          {
            "name": "Canonical/in-place - 2 internal",
            "value": 198.27714285714285,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":700,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 3 internal",
            "value": 371.0186046511628,
            "unit": "ns",
            "extra": "gctime=0\nmemory=608\nallocs=4\nparams={\"evals\":215,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 4 internal",
            "value": 1515.9,
            "unit": "ns",
            "extra": "gctime=0\nmemory=720\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 5 internal",
            "value": 16575.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=29376\nallocs=123\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 2 internal",
            "value": 1488.8,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3744\nallocs=38\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 3 internal",
            "value": 3634.25,
            "unit": "ns",
            "extra": "gctime=0\nmemory=9008\nallocs=83\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 4 internal",
            "value": 13946,
            "unit": "ns",
            "extra": "gctime=0\nmemory=34352\nallocs=282\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 5 internal",
            "value": 82224,
            "unit": "ns",
            "extra": "gctime=0\nmemory=201296\nallocs=1458\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 2 internal",
            "value": 967.7121212121212,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2224\nallocs=27\nparams={\"evals\":66,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 3 internal",
            "value": 1770.2,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3808\nallocs=48\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 4 internal",
            "value": 5770.833333333333,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11520\nallocs=139\nparams={\"evals\":6,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 5 internal",
            "value": 38021,
            "unit": "ns",
            "extra": "gctime=0\nmemory=78656\nallocs=739\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 2 loops",
            "value": 12313,
            "unit": "ns",
            "extra": "gctime=0\nmemory=21856\nallocs=340\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 3 loops",
            "value": 111608,
            "unit": "ns",
            "extra": "gctime=0\nmemory=178016\nallocs=2398\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 4 loops",
            "value": 3115060.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2612400\nallocs=30048\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 5 loops",
            "value": 385247991,
            "unit": "ns",
            "extra": "gctime=18437144\nmemory=551496896\nallocs=2668796\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 2 loops",
            "value": 1378.6,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2336\nallocs=21\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 3 loops",
            "value": 11020,
            "unit": "ns",
            "extra": "gctime=0\nmemory=17648\nallocs=106\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 4 loops",
            "value": 160955.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=277264\nallocs=1337\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 5 loops",
            "value": 4461361,
            "unit": "ns",
            "extra": "gctime=0\nmemory=6349696\nallocs=26462\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 12633,
            "unit": "ns",
            "extra": "gctime=0\nmemory=21952\nallocs=341\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 111738,
            "unit": "ns",
            "extra": "gctime=0\nmemory=178112\nallocs=2399\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cached",
            "value": 220,
            "unit": "ns",
            "extra": "gctime=0\nmemory=192\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cold",
            "value": 102391,
            "unit": "ns",
            "extra": "gctime=0\nmemory=336528\nallocs=3021\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/allgraphs production",
            "value": 12423,
            "unit": "ns",
            "extra": "gctime=0\nmemory=21952\nallocs=341\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/canonical form",
            "value": 199.84347826086957,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":690,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/connected filter",
            "value": 484453,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1114752\nallocs=13755\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/isomorphism reduction",
            "value": 215797.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=393856\nallocs=3077\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
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
          "id": "946e8c3fddb86f68696ea879f7c4394fede7c928",
          "message": "perf: add partition-aware canonical keys (#94)",
          "timestamp": "2026-09-11T08:04:25+02:00",
          "tree_id": "f761ce13fd6f71f2900c9bdd6d1517c814033beb",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/946e8c3fddb86f68696ea879f7c4394fede7c928"
        },
        "date": 1789106987631,
        "tool": "julia",
        "benches": [
          {
            "name": "Canonical/in-place - 2 internal",
            "value": 199.83475177304965,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":705,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 3 internal",
            "value": 367.3860465116279,
            "unit": "ns",
            "extra": "gctime=0\nmemory=608\nallocs=4\nparams={\"evals\":215,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 4 internal",
            "value": 1500.35,
            "unit": "ns",
            "extra": "gctime=0\nmemory=720\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 5 internal",
            "value": 25808.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=29376\nallocs=123\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place mixed - 4 internal",
            "value": 1233.3,
            "unit": "ns",
            "extra": "gctime=0\nmemory=624\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key - 5 internal",
            "value": 4896.357142857143,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11920\nallocs=142\nparams={\"evals\":7,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key mixed - 4 internal",
            "value": 3653.125,
            "unit": "ns",
            "extra": "gctime=0\nmemory=8960\nallocs=110\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key symmetric - 5 internal",
            "value": 3248.625,
            "unit": "ns",
            "extra": "gctime=0\nmemory=7680\nallocs=77\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 2 internal",
            "value": 1486.8,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3744\nallocs=38\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 3 internal",
            "value": 3620.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=9008\nallocs=83\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 4 internal",
            "value": 14206,
            "unit": "ns",
            "extra": "gctime=0\nmemory=34352\nallocs=282\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 5 internal",
            "value": 80771,
            "unit": "ns",
            "extra": "gctime=0\nmemory=201296\nallocs=1458\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 2 internal",
            "value": 940.2786885245902,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2224\nallocs=27\nparams={\"evals\":61,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 3 internal",
            "value": 1739.3,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3808\nallocs=48\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 4 internal",
            "value": 5774.166666666667,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11520\nallocs=139\nparams={\"evals\":6,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 5 internal",
            "value": 36478,
            "unit": "ns",
            "extra": "gctime=0\nmemory=78656\nallocs=739\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 2 loops",
            "value": 12463,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22384\nallocs=344\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 3 loops",
            "value": 111729,
            "unit": "ns",
            "extra": "gctime=0\nmemory=178544\nallocs=2402\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 4 loops",
            "value": 3098195,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2614368\nallocs=30055\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 5 loops",
            "value": 140653435,
            "unit": "ns",
            "extra": "gctime=14859488.5\nmemory=255484080\nallocs=3016893\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 2 loops",
            "value": 1369.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2336\nallocs=21\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 3 loops",
            "value": 10570,
            "unit": "ns",
            "extra": "gctime=0\nmemory=17648\nallocs=106\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 4 loops",
            "value": 160735.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=277264\nallocs=1337\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 5 loops",
            "value": 4337121.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=6349696\nallocs=26462\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 12774,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22480\nallocs=345\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 112625.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=178640\nallocs=2403\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cached",
            "value": 230,
            "unit": "ns",
            "extra": "gctime=0\nmemory=192\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cold",
            "value": 99736,
            "unit": "ns",
            "extra": "gctime=0\nmemory=336528\nallocs=3021\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/allgraphs production",
            "value": 12544,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22480\nallocs=345\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/canonical form",
            "value": 197.7124087591241,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":685,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/connected filter",
            "value": 475279.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1114752\nallocs=13755\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/isomorphism reduction",
            "value": 210013,
            "unit": "ns",
            "extra": "gctime=0\nmemory=393856\nallocs=3077\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
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
          "id": "943227398dc80c0bef3c23a7844ca58c93e6e463",
          "message": "perf: quotient isomorphic row states during generation (#97)",
          "timestamp": "2026-09-11T08:05:24+02:00",
          "tree_id": "490b6d5a4208bb04088155fcdd9d7bedbc2aee64",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/943227398dc80c0bef3c23a7844ca58c93e6e463"
        },
        "date": 1789107072475,
        "tool": "julia",
        "benches": [
          {
            "name": "Canonical/in-place - 2 internal",
            "value": 197.34782608695653,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":690,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 3 internal",
            "value": 368.0837209302326,
            "unit": "ns",
            "extra": "gctime=0\nmemory=608\nallocs=4\nparams={\"evals\":215,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 4 internal",
            "value": 1526.8,
            "unit": "ns",
            "extra": "gctime=0\nmemory=720\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 5 internal",
            "value": 15699,
            "unit": "ns",
            "extra": "gctime=0\nmemory=29376\nallocs=123\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place mixed - 4 internal",
            "value": 1228.3,
            "unit": "ns",
            "extra": "gctime=0\nmemory=624\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key - 5 internal",
            "value": 4874.857142857143,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11920\nallocs=142\nparams={\"evals\":7,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key mixed - 4 internal",
            "value": 3676.875,
            "unit": "ns",
            "extra": "gctime=0\nmemory=8960\nallocs=110\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key symmetric - 5 internal",
            "value": 3268.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=7680\nallocs=77\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 2 internal",
            "value": 1554.9,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3744\nallocs=38\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 3 internal",
            "value": 3829.625,
            "unit": "ns",
            "extra": "gctime=0\nmemory=9008\nallocs=83\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 4 internal",
            "value": 14897,
            "unit": "ns",
            "extra": "gctime=0\nmemory=34352\nallocs=282\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 5 internal",
            "value": 83526,
            "unit": "ns",
            "extra": "gctime=0\nmemory=201296\nallocs=1458\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 2 internal",
            "value": 950.4814814814815,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2224\nallocs=27\nparams={\"evals\":54,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 3 internal",
            "value": 1734.2,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3808\nallocs=48\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 4 internal",
            "value": 5712.333333333333,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11520\nallocs=139\nparams={\"evals\":6,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 5 internal",
            "value": 37249,
            "unit": "ns",
            "extra": "gctime=0\nmemory=78656\nallocs=739\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 2 loops",
            "value": 12473,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22384\nallocs=344\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 3 loops",
            "value": 111188,
            "unit": "ns",
            "extra": "gctime=0\nmemory=178544\nallocs=2402\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 4 loops",
            "value": 3119803,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2614368\nallocs=30055\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 5 loops",
            "value": 142884227,
            "unit": "ns",
            "extra": "gctime=15352370\nmemory=255484080\nallocs=3016893\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 2 loops",
            "value": 1389.7,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2336\nallocs=21\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 3 loops",
            "value": 10490,
            "unit": "ns",
            "extra": "gctime=0\nmemory=17648\nallocs=106\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 4 loops",
            "value": 159427.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=277264\nallocs=1337\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 5 loops",
            "value": 4519268,
            "unit": "ns",
            "extra": "gctime=0\nmemory=6349696\nallocs=26462\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 13114,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 111808,
            "unit": "ns",
            "extra": "gctime=0\nmemory=179064\nallocs=2426\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cached",
            "value": 230,
            "unit": "ns",
            "extra": "gctime=0\nmemory=192\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cold",
            "value": 99185.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=336528\nallocs=3021\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/allgraphs production",
            "value": 13034,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/canonical form",
            "value": 196.784140969163,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":681,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/connected filter",
            "value": 478384,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1114752\nallocs=13755\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/isomorphism reduction",
            "value": 211500,
            "unit": "ns",
            "extra": "gctime=0\nmemory=393856\nallocs=3077\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 3 loops",
            "value": 203400,
            "unit": "ns",
            "extra": "gctime=0\nmemory=411312\nallocs=5345\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 4 loops",
            "value": 1590942,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3015744\nallocs=37767\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 5 loops",
            "value": 15468766,
            "unit": "ns",
            "extra": "gctime=0\nmemory=29503056\nallocs=319058\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
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
          "id": "c80641c571482dae5e63c2c86e0a2934ed983715",
          "message": "perf: avoid per-permutation edge sorting in row-state final labels\n\nUse an exact multiplicity-matrix comparison for the row-state generator's final legacy-compatible canonical-label conversion. Preserve public canonical representatives and exact BigInt symmetry data while retaining canonical_form and _allgraphs_direct as independent/reference implementations.\n\nRefs #98. Closes #100.",
          "timestamp": "2026-09-11T08:58:52+02:00",
          "tree_id": "11413352c04a43fe1a7fcd001a24c0f7e2f0325c",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/c80641c571482dae5e63c2c86e0a2934ed983715"
        },
        "date": 1789110283107,
        "tool": "julia",
        "benches": [
          {
            "name": "Canonical/in-place - 2 internal",
            "value": 198.60355029585799,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":676,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 3 internal",
            "value": 370.1737089201878,
            "unit": "ns",
            "extra": "gctime=0\nmemory=608\nallocs=4\nparams={\"evals\":213,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 4 internal",
            "value": 1509.8,
            "unit": "ns",
            "extra": "gctime=0\nmemory=720\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 5 internal",
            "value": 17152,
            "unit": "ns",
            "extra": "gctime=0\nmemory=29376\nallocs=123\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place mixed - 4 internal",
            "value": 1218.3,
            "unit": "ns",
            "extra": "gctime=0\nmemory=624\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 3 internal",
            "value": 301.77241379310345,
            "unit": "ns",
            "extra": "gctime=0\nmemory=672\nallocs=5\nparams={\"evals\":290,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 4 internal",
            "value": 660.9548022598871,
            "unit": "ns",
            "extra": "gctime=0\nmemory=864\nallocs=5\nparams={\"evals\":177,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 5 internal",
            "value": 2834.1111111111113,
            "unit": "ns",
            "extra": "gctime=0\nmemory=976\nallocs=5\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key - 5 internal",
            "value": 5005,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11920\nallocs=142\nparams={\"evals\":7,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key mixed - 4 internal",
            "value": 3715.625,
            "unit": "ns",
            "extra": "gctime=0\nmemory=8960\nallocs=110\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key symmetric - 5 internal",
            "value": 3321.25,
            "unit": "ns",
            "extra": "gctime=0\nmemory=7680\nallocs=77\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 2 internal",
            "value": 1527.9,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3744\nallocs=38\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 3 internal",
            "value": 3737,
            "unit": "ns",
            "extra": "gctime=0\nmemory=9008\nallocs=83\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 4 internal",
            "value": 14221.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=34352\nallocs=282\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 5 internal",
            "value": 82714,
            "unit": "ns",
            "extra": "gctime=0\nmemory=201296\nallocs=1458\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 2 internal",
            "value": 971.5853658536586,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2224\nallocs=27\nparams={\"evals\":41,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 3 internal",
            "value": 1769.3,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3808\nallocs=48\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 4 internal",
            "value": 5911,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11520\nallocs=139\nparams={\"evals\":6,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 5 internal",
            "value": 38642,
            "unit": "ns",
            "extra": "gctime=0\nmemory=78656\nallocs=739\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 2 loops",
            "value": 12674,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22384\nallocs=344\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 3 loops",
            "value": 112520,
            "unit": "ns",
            "extra": "gctime=0\nmemory=178544\nallocs=2402\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 4 loops",
            "value": 3110338,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2614368\nallocs=30055\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 5 loops",
            "value": 145935680,
            "unit": "ns",
            "extra": "gctime=17496978\nmemory=255484080\nallocs=3016893\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 2 loops",
            "value": 1397.6,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2336\nallocs=21\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 3 loops",
            "value": 11331,
            "unit": "ns",
            "extra": "gctime=0\nmemory=17648\nallocs=106\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 4 loops",
            "value": 162859,
            "unit": "ns",
            "extra": "gctime=0\nmemory=277264\nallocs=1337\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 5 loops",
            "value": 4672233,
            "unit": "ns",
            "extra": "gctime=0\nmemory=6349696\nallocs=26462\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 13075,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 113502,
            "unit": "ns",
            "extra": "gctime=0\nmemory=179064\nallocs=2426\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cached",
            "value": 220,
            "unit": "ns",
            "extra": "gctime=0\nmemory=192\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cold",
            "value": 102882,
            "unit": "ns",
            "extra": "gctime=0\nmemory=336528\nallocs=3021\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/allgraphs production",
            "value": 13089.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/canonical form",
            "value": 199.70724637681158,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":690,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/connected filter",
            "value": 488041,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1114752\nallocs=13755\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/isomorphism reduction",
            "value": 213809.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=393856\nallocs=3077\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 3 loops",
            "value": 208239,
            "unit": "ns",
            "extra": "gctime=0\nmemory=411952\nallocs=5355\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 4 loops",
            "value": 1551920,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3021360\nallocs=37806\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 5 loops",
            "value": 12756495,
            "unit": "ns",
            "extra": "gctime=0\nmemory=24594576\nallocs=298664\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
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
          "id": "d022523d7a8004404141e55288b6864a640fe623",
          "message": "release: prepare v0.2.0\n\nPrepare GraphCombinations.jl v0.2.0 from the certified release candidate.\n\nCloses #86.",
          "timestamp": "2026-09-11T09:18:28+02:00",
          "tree_id": "7330e7450e102dd71caafe22bda8b6f187e53ea5",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/d022523d7a8004404141e55288b6864a640fe623"
        },
        "date": 1789111467820,
        "tool": "julia",
        "benches": [
          {
            "name": "Canonical/in-place - 2 internal",
            "value": 200.845,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":700,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 3 internal",
            "value": 374.74285714285713,
            "unit": "ns",
            "extra": "gctime=0\nmemory=608\nallocs=4\nparams={\"evals\":210,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 4 internal",
            "value": 1758.3,
            "unit": "ns",
            "extra": "gctime=0\nmemory=720\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 5 internal",
            "value": 18324,
            "unit": "ns",
            "extra": "gctime=0\nmemory=29376\nallocs=123\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place mixed - 4 internal",
            "value": 1236.3,
            "unit": "ns",
            "extra": "gctime=0\nmemory=624\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 3 internal",
            "value": 302.77258064516127,
            "unit": "ns",
            "extra": "gctime=0\nmemory=672\nallocs=5\nparams={\"evals\":310,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 4 internal",
            "value": 665.5266272189349,
            "unit": "ns",
            "extra": "gctime=0\nmemory=864\nallocs=5\nparams={\"evals\":169,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 5 internal",
            "value": 2885.3333333333335,
            "unit": "ns",
            "extra": "gctime=0\nmemory=976\nallocs=5\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key - 5 internal",
            "value": 5062.285714285715,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11920\nallocs=142\nparams={\"evals\":7,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key mixed - 4 internal",
            "value": 3765.75,
            "unit": "ns",
            "extra": "gctime=0\nmemory=8960\nallocs=110\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key symmetric - 5 internal",
            "value": 3375.125,
            "unit": "ns",
            "extra": "gctime=0\nmemory=7680\nallocs=77\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 2 internal",
            "value": 1553.85,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3744\nallocs=38\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 3 internal",
            "value": 3793.25,
            "unit": "ns",
            "extra": "gctime=0\nmemory=9008\nallocs=83\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 4 internal",
            "value": 14457,
            "unit": "ns",
            "extra": "gctime=0\nmemory=34352\nallocs=282\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 5 internal",
            "value": 84237,
            "unit": "ns",
            "extra": "gctime=0\nmemory=201296\nallocs=1458\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 2 internal",
            "value": 1025.9298245614036,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2224\nallocs=27\nparams={\"evals\":57,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 3 internal",
            "value": 1840.4,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3808\nallocs=48\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 4 internal",
            "value": 5947.833333333333,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11520\nallocs=139\nparams={\"evals\":6,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 5 internal",
            "value": 39573,
            "unit": "ns",
            "extra": "gctime=0\nmemory=78656\nallocs=739\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 2 loops",
            "value": 12513,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22384\nallocs=344\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 3 loops",
            "value": 111969,
            "unit": "ns",
            "extra": "gctime=0\nmemory=178544\nallocs=2402\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 4 loops",
            "value": 3117795,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2614368\nallocs=30055\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 5 loops",
            "value": 148807686,
            "unit": "ns",
            "extra": "gctime=18265851.5\nmemory=255484080\nallocs=3016893\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 2 loops",
            "value": 1407.6,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2336\nallocs=21\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 3 loops",
            "value": 11001,
            "unit": "ns",
            "extra": "gctime=0\nmemory=17648\nallocs=106\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 4 loops",
            "value": 163524.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=277264\nallocs=1337\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 5 loops",
            "value": 4673707,
            "unit": "ns",
            "extra": "gctime=0\nmemory=6349696\nallocs=26462\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 13385,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 112589,
            "unit": "ns",
            "extra": "gctime=0\nmemory=179064\nallocs=2426\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cached",
            "value": 230,
            "unit": "ns",
            "extra": "gctime=0\nmemory=192\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cold",
            "value": 104514,
            "unit": "ns",
            "extra": "gctime=0\nmemory=336528\nallocs=3021\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/allgraphs production",
            "value": 12984,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/canonical form",
            "value": 204.26277372262774,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":685,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/connected filter",
            "value": 489755.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1114752\nallocs=13755\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/isomorphism reduction",
            "value": 216588,
            "unit": "ns",
            "extra": "gctime=0\nmemory=393856\nallocs=3077\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 3 loops",
            "value": 208392.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=411952\nallocs=5355\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 4 loops",
            "value": 1569773,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3021360\nallocs=37806\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 5 loops",
            "value": 12979341.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=24594576\nallocs=298664\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
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
          "id": "bded8da1c69adfc81afc1b4c6c1006e10b17b9f7",
          "message": "ci: fix benchmark alert permissions and trigger path\n\nAllow Benchmark Tracking to comment on performance alerts and make changes to Benchmarks.yaml trigger the workflow itself.\n\nCloses #96.",
          "timestamp": "2026-09-11T09:36:45+02:00",
          "tree_id": "1f8fbae6ae3819f3b8a3379a7e4d58f35b5f2907",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/bded8da1c69adfc81afc1b4c6c1006e10b17b9f7"
        },
        "date": 1789112645865,
        "tool": "julia",
        "benches": [
          {
            "name": "Canonical/in-place - 2 internal",
            "value": 207.45795795795794,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":666,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 3 internal",
            "value": 382.8357487922705,
            "unit": "ns",
            "extra": "gctime=0\nmemory=608\nallocs=4\nparams={\"evals\":207,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 4 internal",
            "value": 1644.1,
            "unit": "ns",
            "extra": "gctime=0\nmemory=720\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 5 internal",
            "value": 17854,
            "unit": "ns",
            "extra": "gctime=0\nmemory=29376\nallocs=123\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place mixed - 4 internal",
            "value": 1270.4,
            "unit": "ns",
            "extra": "gctime=0\nmemory=624\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 3 internal",
            "value": 310.72727272727275,
            "unit": "ns",
            "extra": "gctime=0\nmemory=672\nallocs=5\nparams={\"evals\":264,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 4 internal",
            "value": 665.2861271676301,
            "unit": "ns",
            "extra": "gctime=0\nmemory=864\nallocs=5\nparams={\"evals\":173,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 5 internal",
            "value": 2844.222222222222,
            "unit": "ns",
            "extra": "gctime=0\nmemory=976\nallocs=5\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key - 5 internal",
            "value": 5110.857142857143,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11920\nallocs=142\nparams={\"evals\":7,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key mixed - 4 internal",
            "value": 3785.75,
            "unit": "ns",
            "extra": "gctime=0\nmemory=8960\nallocs=110\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key symmetric - 5 internal",
            "value": 3387.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=7680\nallocs=77\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 2 internal",
            "value": 1541.9,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3744\nallocs=38\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 3 internal",
            "value": 3758.25,
            "unit": "ns",
            "extra": "gctime=0\nmemory=9008\nallocs=83\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 4 internal",
            "value": 14307,
            "unit": "ns",
            "extra": "gctime=0\nmemory=34352\nallocs=282\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 5 internal",
            "value": 84051.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=201296\nallocs=1458\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 2 internal",
            "value": 956.4146341463414,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2224\nallocs=27\nparams={\"evals\":41,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 3 internal",
            "value": 1745.3,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3808\nallocs=48\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 4 internal",
            "value": 5822.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11520\nallocs=139\nparams={\"evals\":6,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 5 internal",
            "value": 39273,
            "unit": "ns",
            "extra": "gctime=0\nmemory=78656\nallocs=739\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 2 loops",
            "value": 12473,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22384\nallocs=344\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 3 loops",
            "value": 113371,
            "unit": "ns",
            "extra": "gctime=0\nmemory=178544\nallocs=2402\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 4 loops",
            "value": 3104218.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2614368\nallocs=30055\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 5 loops",
            "value": 148851694.5,
            "unit": "ns",
            "extra": "gctime=18369462\nmemory=255484080\nallocs=3016893\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 2 loops",
            "value": 1394.6,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2336\nallocs=21\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 3 loops",
            "value": 11151,
            "unit": "ns",
            "extra": "gctime=0\nmemory=17648\nallocs=106\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 4 loops",
            "value": 162563,
            "unit": "ns",
            "extra": "gctime=0\nmemory=277264\nallocs=1337\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 5 loops",
            "value": 4570331.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=6349696\nallocs=26462\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 13144,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 115175,
            "unit": "ns",
            "extra": "gctime=0\nmemory=179064\nallocs=2426\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cached",
            "value": 220,
            "unit": "ns",
            "extra": "gctime=0\nmemory=192\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cold",
            "value": 102962,
            "unit": "ns",
            "extra": "gctime=0\nmemory=336528\nallocs=3021\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/allgraphs production",
            "value": 13074,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/canonical form",
            "value": 209.6280487804878,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":656,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/connected filter",
            "value": 487232,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1114752\nallocs=13755\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/isomorphism reduction",
            "value": 219689,
            "unit": "ns",
            "extra": "gctime=0\nmemory=393856\nallocs=3077\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 3 loops",
            "value": 209369,
            "unit": "ns",
            "extra": "gctime=0\nmemory=411952\nallocs=5355\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 4 loops",
            "value": 1575222,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3021360\nallocs=37806\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 5 loops",
            "value": 12996491,
            "unit": "ns",
            "extra": "gctime=0\nmemory=24594576\nallocs=298664\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
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
          "id": "8627826d13cb0107d8db8568f018446a1039cfdf",
          "message": "fix: guard exact counters against integer overflow\n\nKeep automorphism and partition counters machine-sized on the hot path, but use checked increments so exact symmetry bookkeeping can never silently wrap.\n\nCloses #95.",
          "timestamp": "2026-09-11T09:57:58+02:00",
          "tree_id": "25fafed6d4c3618836ef2480739b4aece5aaa8a5",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/8627826d13cb0107d8db8568f018446a1039cfdf"
        },
        "date": 1789114129301,
        "tool": "julia",
        "benches": [
          {
            "name": "Canonical/in-place - 2 internal",
            "value": 211.46795827123697,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":671,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 3 internal",
            "value": 396.7826086956522,
            "unit": "ns",
            "extra": "gctime=0\nmemory=608\nallocs=4\nparams={\"evals\":207,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 4 internal",
            "value": 1835.8,
            "unit": "ns",
            "extra": "gctime=0\nmemory=720\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 5 internal",
            "value": 18078,
            "unit": "ns",
            "extra": "gctime=0\nmemory=29376\nallocs=123\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place mixed - 4 internal",
            "value": 1298,
            "unit": "ns",
            "extra": "gctime=0\nmemory=624\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 3 internal",
            "value": 324.94565217391306,
            "unit": "ns",
            "extra": "gctime=0\nmemory=672\nallocs=5\nparams={\"evals\":276,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 4 internal",
            "value": 694.3006134969326,
            "unit": "ns",
            "extra": "gctime=0\nmemory=864\nallocs=5\nparams={\"evals\":163,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 5 internal",
            "value": 2953.3333333333335,
            "unit": "ns",
            "extra": "gctime=0\nmemory=976\nallocs=5\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key - 5 internal",
            "value": 5086.928571428572,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11920\nallocs=142\nparams={\"evals\":7,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key mixed - 4 internal",
            "value": 3769.375,
            "unit": "ns",
            "extra": "gctime=0\nmemory=8960\nallocs=110\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key symmetric - 5 internal",
            "value": 3511.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=7680\nallocs=77\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 2 internal",
            "value": 1580.4,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3744\nallocs=38\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 3 internal",
            "value": 3875.875,
            "unit": "ns",
            "extra": "gctime=0\nmemory=9008\nallocs=83\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 4 internal",
            "value": 14873,
            "unit": "ns",
            "extra": "gctime=0\nmemory=34352\nallocs=282\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 5 internal",
            "value": 85940,
            "unit": "ns",
            "extra": "gctime=0\nmemory=201296\nallocs=1458\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 2 internal",
            "value": 1000.01,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2224\nallocs=27\nparams={\"evals\":50,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 3 internal",
            "value": 1870.35,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3808\nallocs=48\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 4 internal",
            "value": 6226,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11520\nallocs=139\nparams={\"evals\":6,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 5 internal",
            "value": 38789,
            "unit": "ns",
            "extra": "gctime=0\nmemory=78656\nallocs=739\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 2 loops",
            "value": 12659,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22384\nallocs=344\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 3 loops",
            "value": 109776,
            "unit": "ns",
            "extra": "gctime=0\nmemory=178544\nallocs=2402\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 4 loops",
            "value": 3313664,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2614368\nallocs=30055\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 5 loops",
            "value": 155915299,
            "unit": "ns",
            "extra": "gctime=22503834\nmemory=255484080\nallocs=3016893\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 2 loops",
            "value": 1476.2,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2336\nallocs=21\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 3 loops",
            "value": 11778,
            "unit": "ns",
            "extra": "gctime=0\nmemory=17648\nallocs=106\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 4 loops",
            "value": 167563.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=277264\nallocs=1337\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 5 loops",
            "value": 5103498.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=6349696\nallocs=26462\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 13420,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 110878,
            "unit": "ns",
            "extra": "gctime=0\nmemory=179064\nallocs=2426\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cached",
            "value": 220,
            "unit": "ns",
            "extra": "gctime=0\nmemory=192\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cold",
            "value": 113681,
            "unit": "ns",
            "extra": "gctime=0\nmemory=336528\nallocs=3021\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/allgraphs production",
            "value": 13190,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/canonical form",
            "value": 213.17660208643815,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":671,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/connected filter",
            "value": 497412,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1114752\nallocs=13755\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/isomorphism reduction",
            "value": 225270,
            "unit": "ns",
            "extra": "gctime=0\nmemory=393856\nallocs=3077\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 3 loops",
            "value": 211520,
            "unit": "ns",
            "extra": "gctime=0\nmemory=411952\nallocs=5355\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 4 loops",
            "value": 1594289,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3021360\nallocs=37806\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 5 loops",
            "value": 13350273.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=24594576\nallocs=298664\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
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
          "id": "ed50778aa2189ccf36161da531406291691f5431",
          "message": "refactor: move reference machinery out of runtime path (#105)\n\nMove Wick enumeration, legacy Combinatorics-based canonicalizers, and reference reduction into a repository-level reference module loaded only by tests and benchmarks. Make Combinatorics and Memoization test/benchmark-only dependencies while preserving the independent exhaustive oracle and its historical benchmark behavior.\n\nCloses #87.",
          "timestamp": "2026-09-11T10:47:52+02:00",
          "tree_id": "9a3ebaa5a2e7593594f2a6887447babcaec81254",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/ed50778aa2189ccf36161da531406291691f5431"
        },
        "date": 1789117923644,
        "tool": "julia",
        "benches": [
          {
            "name": "Canonical/in-place - 2 internal",
            "value": 123.74973488865324,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":943,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 3 internal",
            "value": 229.25636363636363,
            "unit": "ns",
            "extra": "gctime=0\nmemory=608\nallocs=4\nparams={\"evals\":550,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 4 internal",
            "value": 805.6306306306307,
            "unit": "ns",
            "extra": "gctime=0\nmemory=720\nallocs=4\nparams={\"evals\":111,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 5 internal",
            "value": 9582,
            "unit": "ns",
            "extra": "gctime=0\nmemory=29376\nallocs=123\nparams={\"evals\":4,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place mixed - 4 internal",
            "value": 636.2196531791908,
            "unit": "ns",
            "extra": "gctime=0\nmemory=624\nallocs=4\nparams={\"evals\":173,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 3 internal",
            "value": 197.3270013568521,
            "unit": "ns",
            "extra": "gctime=0\nmemory=672\nallocs=5\nparams={\"evals\":737,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 4 internal",
            "value": 433.91,
            "unit": "ns",
            "extra": "gctime=0\nmemory=864\nallocs=5\nparams={\"evals\":200,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 5 internal",
            "value": 1939.9,
            "unit": "ns",
            "extra": "gctime=0\nmemory=976\nallocs=5\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key - 5 internal",
            "value": 3273.8888888888887,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11920\nallocs=142\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key mixed - 4 internal",
            "value": 2393.6666666666665,
            "unit": "ns",
            "extra": "gctime=0\nmemory=8960\nallocs=110\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key symmetric - 5 internal",
            "value": 2124.3333333333335,
            "unit": "ns",
            "extra": "gctime=0\nmemory=7680\nallocs=77\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 2 internal",
            "value": 975.7843137254902,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3744\nallocs=38\nparams={\"evals\":51,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 3 internal",
            "value": 2383.6666666666665,
            "unit": "ns",
            "extra": "gctime=0\nmemory=9008\nallocs=83\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 4 internal",
            "value": 9020.333333333334,
            "unit": "ns",
            "extra": "gctime=0\nmemory=34352\nallocs=282\nparams={\"evals\":3,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 5 internal",
            "value": 52740,
            "unit": "ns",
            "extra": "gctime=0\nmemory=201296\nallocs=1458\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 2 internal",
            "value": 593.0925925925926,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2224\nallocs=27\nparams={\"evals\":189,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 3 internal",
            "value": 1115.6,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3808\nallocs=48\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 4 internal",
            "value": 3743.125,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11520\nallocs=139\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 5 internal",
            "value": 29785,
            "unit": "ns",
            "extra": "gctime=0\nmemory=78656\nallocs=739\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 2 loops",
            "value": 7889.25,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22384\nallocs=344\nparams={\"evals\":4,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 3 loops",
            "value": 69215,
            "unit": "ns",
            "extra": "gctime=0\nmemory=178544\nallocs=2402\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 4 loops",
            "value": 2047339.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2614368\nallocs=30055\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 5 loops",
            "value": 103957006,
            "unit": "ns",
            "extra": "gctime=18204710.5\nmemory=255484080\nallocs=3016893\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 2 loops",
            "value": 838.0040322580645,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2336\nallocs=21\nparams={\"evals\":124,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 3 loops",
            "value": 6476.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=17648\nallocs=106\nparams={\"evals\":6,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 4 loops",
            "value": 94658.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=277264\nallocs=1337\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 5 loops",
            "value": 2891783.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=6349696\nallocs=26462\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 8380.25,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":4,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 70156,
            "unit": "ns",
            "extra": "gctime=0\nmemory=179064\nallocs=2426\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cached",
            "value": 110,
            "unit": "ns",
            "extra": "gctime=0\nmemory=192\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cold",
            "value": 70096,
            "unit": "ns",
            "extra": "gctime=0\nmemory=336528\nallocs=3021\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/allgraphs production",
            "value": 9074,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/canonical form",
            "value": 125.26943556975506,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":939,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/connected filter",
            "value": 306759,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1114752\nallocs=13755\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/isomorphism reduction",
            "value": 127463,
            "unit": "ns",
            "extra": "gctime=0\nmemory=393856\nallocs=3077\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 3 loops",
            "value": 136356,
            "unit": "ns",
            "extra": "gctime=0\nmemory=411952\nallocs=5355\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 4 loops",
            "value": 1009786,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3021360\nallocs=37806\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 5 loops",
            "value": 8645198,
            "unit": "ns",
            "extra": "gctime=0\nmemory=24594576\nallocs=298664\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
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
          "id": "bf753fcdba7789aec8084bf2acc434565e7d18fe",
          "message": "feat: add weighted colored port generation (#107)\n\nLand the certified generic weighted colored-port matching core and permanent regression benchmarks as the first production tranche of #91.",
          "timestamp": "2026-09-13T09:37:46+02:00",
          "tree_id": "2271383e2af88d8d2135b8887f18507e2a21e803",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/bf753fcdba7789aec8084bf2acc434565e7d18fe"
        },
        "date": 1789285499543,
        "tool": "julia",
        "benches": [
          {
            "name": "Canonical/in-place - 2 internal",
            "value": 179.94850065189047,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":767,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 3 internal",
            "value": 330.3963414634146,
            "unit": "ns",
            "extra": "gctime=0\nmemory=608\nallocs=4\nparams={\"evals\":246,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 4 internal",
            "value": 1207,
            "unit": "ns",
            "extra": "gctime=0\nmemory=720\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 5 internal",
            "value": 13834.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=29376\nallocs=123\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place mixed - 4 internal",
            "value": 978.09375,
            "unit": "ns",
            "extra": "gctime=0\nmemory=624\nallocs=4\nparams={\"evals\":32,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 3 internal",
            "value": 316.60687022900765,
            "unit": "ns",
            "extra": "gctime=0\nmemory=672\nallocs=5\nparams={\"evals\":262,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 4 internal",
            "value": 729.5125,
            "unit": "ns",
            "extra": "gctime=0\nmemory=864\nallocs=5\nparams={\"evals\":160,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 5 internal",
            "value": 2820,
            "unit": "ns",
            "extra": "gctime=0\nmemory=976\nallocs=5\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key - 5 internal",
            "value": 4832.857142857143,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11920\nallocs=142\nparams={\"evals\":7,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key mixed - 4 internal",
            "value": 3654,
            "unit": "ns",
            "extra": "gctime=0\nmemory=8960\nallocs=110\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key symmetric - 5 internal",
            "value": 3378.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=7680\nallocs=77\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 2 internal",
            "value": 1541.8,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3744\nallocs=38\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 3 internal",
            "value": 3707.8125,
            "unit": "ns",
            "extra": "gctime=0\nmemory=9008\nallocs=83\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 4 internal",
            "value": 14555,
            "unit": "ns",
            "extra": "gctime=0\nmemory=34352\nallocs=282\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 5 internal",
            "value": 86041.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=201296\nallocs=1458\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 2 internal",
            "value": 955.2,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2224\nallocs=27\nparams={\"evals\":35,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 3 internal",
            "value": 1802.6,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3808\nallocs=48\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 4 internal",
            "value": 5683.083333333334,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11520\nallocs=139\nparams={\"evals\":6,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 5 internal",
            "value": 34664,
            "unit": "ns",
            "extra": "gctime=0\nmemory=78656\nallocs=739\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 4",
            "value": 2933336,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1570056\nallocs=10675\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 5",
            "value": 77251328,
            "unit": "ns",
            "extra": "gctime=0\nmemory=12383912\nallocs=61830\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 2 loops",
            "value": 12883,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22384\nallocs=344\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 3 loops",
            "value": 113049,
            "unit": "ns",
            "extra": "gctime=0\nmemory=178544\nallocs=2402\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 4 loops",
            "value": 3265507,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2614368\nallocs=30055\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 5 loops",
            "value": 152837854.5,
            "unit": "ns",
            "extra": "gctime=26621064.5\nmemory=255484080\nallocs=3016893\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 2 loops",
            "value": 1472.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2336\nallocs=21\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 3 loops",
            "value": 11153,
            "unit": "ns",
            "extra": "gctime=0\nmemory=17648\nallocs=106\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 4 loops",
            "value": 178242.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=277264\nallocs=1337\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 5 loops",
            "value": 4759493,
            "unit": "ns",
            "extra": "gctime=0\nmemory=6349696\nallocs=26462\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 13401,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 115063,
            "unit": "ns",
            "extra": "gctime=0\nmemory=179064\nallocs=2426\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cached",
            "value": 240,
            "unit": "ns",
            "extra": "gctime=0\nmemory=192\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cold",
            "value": 103674.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=336528\nallocs=3021\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/allgraphs production",
            "value": 13531,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/canonical form",
            "value": 179.00064766839378,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":772,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/connected filter",
            "value": 475334,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1114752\nallocs=13755\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/isomorphism reduction",
            "value": 212601,
            "unit": "ns",
            "extra": "gctime=0\nmemory=393856\nallocs=3077\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 3 loops",
            "value": 219115,
            "unit": "ns",
            "extra": "gctime=0\nmemory=411952\nallocs=5355\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 4 loops",
            "value": 1638576.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3021360\nallocs=37806\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 5 loops",
            "value": 13333933,
            "unit": "ns",
            "extra": "gctime=0\nmemory=24594576\nallocs=298664\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
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
          "id": "f5252cea5c20b7599f77d06dae6a8e674efd8d9b",
          "message": "feat: add monotone colored-port pruning (#109)\n\nLand the certified generic monotone child-state pruning traversal for weighted colored-port generation.",
          "timestamp": "2026-09-13T10:04:24+02:00",
          "tree_id": "9d2f762ed4f10b38ad070150b8cce9b4558118fd",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/f5252cea5c20b7599f77d06dae6a8e674efd8d9b"
        },
        "date": 1789287091016,
        "tool": "julia",
        "benches": [
          {
            "name": "Canonical/in-place - 2 internal",
            "value": 201.01228878648232,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":651,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 3 internal",
            "value": 378.6875,
            "unit": "ns",
            "extra": "gctime=0\nmemory=608\nallocs=4\nparams={\"evals\":208,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 4 internal",
            "value": 1631,
            "unit": "ns",
            "extra": "gctime=0\nmemory=720\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 5 internal",
            "value": 16400,
            "unit": "ns",
            "extra": "gctime=0\nmemory=29376\nallocs=123\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place mixed - 4 internal",
            "value": 1266.4,
            "unit": "ns",
            "extra": "gctime=0\nmemory=624\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 3 internal",
            "value": 308.4152823920266,
            "unit": "ns",
            "extra": "gctime=0\nmemory=672\nallocs=5\nparams={\"evals\":301,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 4 internal",
            "value": 660.8636363636364,
            "unit": "ns",
            "extra": "gctime=0\nmemory=864\nallocs=5\nparams={\"evals\":176,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 5 internal",
            "value": 2835.277777777778,
            "unit": "ns",
            "extra": "gctime=0\nmemory=976\nallocs=5\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key - 5 internal",
            "value": 4977.857142857143,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11920\nallocs=142\nparams={\"evals\":7,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key mixed - 4 internal",
            "value": 3728.25,
            "unit": "ns",
            "extra": "gctime=0\nmemory=8960\nallocs=110\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key symmetric - 5 internal",
            "value": 3290.5625,
            "unit": "ns",
            "extra": "gctime=0\nmemory=7680\nallocs=77\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 2 internal",
            "value": 1500.8,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3744\nallocs=38\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 3 internal",
            "value": 3701.875,
            "unit": "ns",
            "extra": "gctime=0\nmemory=9008\nallocs=83\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 4 internal",
            "value": 14577,
            "unit": "ns",
            "extra": "gctime=0\nmemory=34352\nallocs=282\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 5 internal",
            "value": 80931,
            "unit": "ns",
            "extra": "gctime=0\nmemory=201296\nallocs=1458\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 2 internal",
            "value": 946.8837209302326,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2224\nallocs=27\nparams={\"evals\":43,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 3 internal",
            "value": 1758.3,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3808\nallocs=48\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 4 internal",
            "value": 6215,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11520\nallocs=139\nparams={\"evals\":6,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 5 internal",
            "value": 36588,
            "unit": "ns",
            "extra": "gctime=0\nmemory=78656\nallocs=739\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 4",
            "value": 2624843,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1570056\nallocs=10675\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 5",
            "value": 72282868.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=12417944\nallocs=61834\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 2 loops",
            "value": 12624,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22384\nallocs=344\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 3 loops",
            "value": 111838,
            "unit": "ns",
            "extra": "gctime=0\nmemory=178544\nallocs=2402\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 4 loops",
            "value": 3082360,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2614368\nallocs=30055\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 5 loops",
            "value": 143471811.5,
            "unit": "ns",
            "extra": "gctime=16267329.5\nmemory=255484080\nallocs=3016893\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 2 loops",
            "value": 1397.05,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2336\nallocs=21\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 3 loops",
            "value": 11551.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=17648\nallocs=106\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 4 loops",
            "value": 165087,
            "unit": "ns",
            "extra": "gctime=0\nmemory=277264\nallocs=1337\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 5 loops",
            "value": 4699452,
            "unit": "ns",
            "extra": "gctime=0\nmemory=6349696\nallocs=26462\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 14317,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 113481,
            "unit": "ns",
            "extra": "gctime=0\nmemory=179064\nallocs=2426\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cached",
            "value": 221,
            "unit": "ns",
            "extra": "gctime=0\nmemory=192\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cold",
            "value": 100396,
            "unit": "ns",
            "extra": "gctime=0\nmemory=336528\nallocs=3021\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/allgraphs production",
            "value": 14286,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/canonical form",
            "value": 201.5249621785174,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":661,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/connected filter",
            "value": 485248.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1114752\nallocs=13755\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/isomorphism reduction",
            "value": 217109,
            "unit": "ns",
            "extra": "gctime=0\nmemory=393856\nallocs=3077\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 3 loops",
            "value": 206079.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=411952\nallocs=5355\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 4 loops",
            "value": 1533567,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3021360\nallocs=37806\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 5 loops",
            "value": 12787241.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=24594576\nallocs=298664\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
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
          "id": "f5252cea5c20b7599f77d06dae6a8e674efd8d9b",
          "message": "feat: add monotone colored-port pruning (#109)\n\nLand the certified generic monotone child-state pruning traversal for weighted colored-port generation.",
          "timestamp": "2026-09-13T10:04:24+02:00",
          "tree_id": "9d2f762ed4f10b38ad070150b8cce9b4558118fd",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/f5252cea5c20b7599f77d06dae6a8e674efd8d9b"
        },
        "date": 1789287093095,
        "tool": "julia",
        "benches": [
          {
            "name": "Canonical/in-place - 2 internal",
            "value": 199.3767507002801,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":714,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 3 internal",
            "value": 368.1767441860465,
            "unit": "ns",
            "extra": "gctime=0\nmemory=608\nallocs=4\nparams={\"evals\":215,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 4 internal",
            "value": 1518.8,
            "unit": "ns",
            "extra": "gctime=0\nmemory=720\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 5 internal",
            "value": 18800,
            "unit": "ns",
            "extra": "gctime=0\nmemory=29376\nallocs=123\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place mixed - 4 internal",
            "value": 1187.2,
            "unit": "ns",
            "extra": "gctime=0\nmemory=624\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 3 internal",
            "value": 296.65584415584414,
            "unit": "ns",
            "extra": "gctime=0\nmemory=672\nallocs=5\nparams={\"evals\":308,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 4 internal",
            "value": 626.1095505617977,
            "unit": "ns",
            "extra": "gctime=0\nmemory=864\nallocs=5\nparams={\"evals\":178,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 5 internal",
            "value": 2783,
            "unit": "ns",
            "extra": "gctime=0\nmemory=976\nallocs=5\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key - 5 internal",
            "value": 5922.428571428572,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11920\nallocs=142\nparams={\"evals\":7,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key mixed - 4 internal",
            "value": 4360.625,
            "unit": "ns",
            "extra": "gctime=0\nmemory=8960\nallocs=110\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key symmetric - 5 internal",
            "value": 3670.625,
            "unit": "ns",
            "extra": "gctime=0\nmemory=7680\nallocs=77\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 2 internal",
            "value": 1546.9,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3744\nallocs=38\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 3 internal",
            "value": 3758.375,
            "unit": "ns",
            "extra": "gctime=0\nmemory=9008\nallocs=83\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 4 internal",
            "value": 14868,
            "unit": "ns",
            "extra": "gctime=0\nmemory=34352\nallocs=282\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 5 internal",
            "value": 82764,
            "unit": "ns",
            "extra": "gctime=0\nmemory=201296\nallocs=1458\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 2 internal",
            "value": 1009.9473684210526,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2224\nallocs=27\nparams={\"evals\":57,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 3 internal",
            "value": 1810.4,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3808\nallocs=48\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 4 internal",
            "value": 6186.666666666667,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11520\nallocs=139\nparams={\"evals\":6,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 5 internal",
            "value": 37911,
            "unit": "ns",
            "extra": "gctime=0\nmemory=78656\nallocs=739\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 4",
            "value": 2633318.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1570056\nallocs=10675\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 5",
            "value": 72152707.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=12519368\nallocs=61835\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 2 loops",
            "value": 12723,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22384\nallocs=344\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 3 loops",
            "value": 111628,
            "unit": "ns",
            "extra": "gctime=0\nmemory=178544\nallocs=2402\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 4 loops",
            "value": 3107607,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2614368\nallocs=30055\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 5 loops",
            "value": 145916705,
            "unit": "ns",
            "extra": "gctime=16928101\nmemory=255484080\nallocs=3016893\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 2 loops",
            "value": 1443.7,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2336\nallocs=21\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 3 loops",
            "value": 11131,
            "unit": "ns",
            "extra": "gctime=0\nmemory=17648\nallocs=106\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 4 loops",
            "value": 160308.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=277264\nallocs=1337\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 5 loops",
            "value": 4783893,
            "unit": "ns",
            "extra": "gctime=0\nmemory=6349696\nallocs=26462\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 13355,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 112029,
            "unit": "ns",
            "extra": "gctime=0\nmemory=179064\nallocs=2426\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cached",
            "value": 220,
            "unit": "ns",
            "extra": "gctime=0\nmemory=192\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cold",
            "value": 103543,
            "unit": "ns",
            "extra": "gctime=0\nmemory=336528\nallocs=3021\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/allgraphs production",
            "value": 13275,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/canonical form",
            "value": 209.0272314674735,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":661,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/connected filter",
            "value": 487258,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1114752\nallocs=13755\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/isomorphism reduction",
            "value": 219018,
            "unit": "ns",
            "extra": "gctime=0\nmemory=393856\nallocs=3077\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 3 loops",
            "value": 207842.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=411952\nallocs=5355\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 4 loops",
            "value": 1554725,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3021360\nallocs=37806\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 5 loops",
            "value": 12718723.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=24594576\nallocs=298664\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
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
          "id": "ff07b430af5ee7eb11e3ed279779d11239814b79",
          "message": "release: prepare v0.3.0 (#113)\n\nBump GraphCombinations to v0.3.0 and document the production weighted colored-port API. Release consolidation only; generation and matching semantics are unchanged.\n\nCloses #112.",
          "timestamp": "2026-09-13T11:40:29+02:00",
          "tree_id": "a26a138956cf448726f49e8845d7534c6a7c3812",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/ff07b430af5ee7eb11e3ed279779d11239814b79"
        },
        "date": 1789292814582,
        "tool": "julia",
        "benches": [
          {
            "name": "Canonical/in-place - 2 internal",
            "value": 197.90171606864274,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":641,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 3 internal",
            "value": 364.92452830188677,
            "unit": "ns",
            "extra": "gctime=0\nmemory=608\nallocs=4\nparams={\"evals\":212,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 4 internal",
            "value": 1756.2,
            "unit": "ns",
            "extra": "gctime=0\nmemory=720\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 5 internal",
            "value": 16330.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=29376\nallocs=123\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place mixed - 4 internal",
            "value": 1220.3,
            "unit": "ns",
            "extra": "gctime=0\nmemory=624\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 3 internal",
            "value": 308.2304832713755,
            "unit": "ns",
            "extra": "gctime=0\nmemory=672\nallocs=5\nparams={\"evals\":269,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 4 internal",
            "value": 676.1017964071856,
            "unit": "ns",
            "extra": "gctime=0\nmemory=864\nallocs=5\nparams={\"evals\":167,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 5 internal",
            "value": 2896.5555555555557,
            "unit": "ns",
            "extra": "gctime=0\nmemory=976\nallocs=5\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key - 5 internal",
            "value": 5003.571428571428,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11920\nallocs=142\nparams={\"evals\":7,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key mixed - 4 internal",
            "value": 3803.25,
            "unit": "ns",
            "extra": "gctime=0\nmemory=8960\nallocs=110\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key symmetric - 5 internal",
            "value": 3373.75,
            "unit": "ns",
            "extra": "gctime=0\nmemory=7680\nallocs=77\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 2 internal",
            "value": 1492.8,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3744\nallocs=38\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 3 internal",
            "value": 3678.125,
            "unit": "ns",
            "extra": "gctime=0\nmemory=9008\nallocs=83\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 4 internal",
            "value": 14116,
            "unit": "ns",
            "extra": "gctime=0\nmemory=34352\nallocs=282\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 5 internal",
            "value": 82052,
            "unit": "ns",
            "extra": "gctime=0\nmemory=201296\nallocs=1458\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 2 internal",
            "value": 932.5744680851063,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2224\nallocs=27\nparams={\"evals\":47,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 3 internal",
            "value": 1722.2,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3808\nallocs=48\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 4 internal",
            "value": 5727.333333333333,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11520\nallocs=139\nparams={\"evals\":6,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 5 internal",
            "value": 39127.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=78656\nallocs=739\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 4",
            "value": 2668864,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1570056\nallocs=10675\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 4 public",
            "value": 2675094,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1571608\nallocs=10677\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 5",
            "value": 72548374,
            "unit": "ns",
            "extra": "gctime=0\nmemory=12790280\nallocs=61845\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 2 loops",
            "value": 12624,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22384\nallocs=344\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 3 loops",
            "value": 111857,
            "unit": "ns",
            "extra": "gctime=0\nmemory=178544\nallocs=2402\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 4 loops",
            "value": 3102656,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2614368\nallocs=30055\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 5 loops",
            "value": 142083204,
            "unit": "ns",
            "extra": "gctime=15842311\nmemory=255484080\nallocs=3016893\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 2 loops",
            "value": 1404.6,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2336\nallocs=21\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 3 loops",
            "value": 10800,
            "unit": "ns",
            "extra": "gctime=0\nmemory=17648\nallocs=106\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 4 loops",
            "value": 162426,
            "unit": "ns",
            "extra": "gctime=0\nmemory=277264\nallocs=1337\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 5 loops",
            "value": 4761312.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=6349696\nallocs=26462\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 13405,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 112117,
            "unit": "ns",
            "extra": "gctime=0\nmemory=179064\nallocs=2426\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cached",
            "value": 211,
            "unit": "ns",
            "extra": "gctime=0\nmemory=192\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cold",
            "value": 99263,
            "unit": "ns",
            "extra": "gctime=0\nmemory=336528\nallocs=3021\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/allgraphs production",
            "value": 13355,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/canonical form",
            "value": 200.26861313868613,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":685,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/connected filter",
            "value": 503142,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1114752\nallocs=13755\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/isomorphism reduction",
            "value": 213124.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=393856\nallocs=3077\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 3 loops",
            "value": 206453,
            "unit": "ns",
            "extra": "gctime=0\nmemory=411952\nallocs=5355\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 4 loops",
            "value": 1542536.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3021360\nallocs=37806\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 5 loops",
            "value": 12622998,
            "unit": "ns",
            "extra": "gctime=0\nmemory=24594576\nallocs=298664\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
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
            "email": "orjan.ameye@hotmail.com",
            "name": "Orjan Ameye",
            "username": "oameye"
          },
          "distinct": false,
          "id": "f4fd1e381ad728033a7abb38e7e95b85eac264de",
          "message": "test: enforce package-wide DispatchDoctor type stability",
          "timestamp": "2026-09-13T15:10:04+02:00",
          "tree_id": "e97680b0820cd65dced31b1686290fedbf6d452e",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/f4fd1e381ad728033a7abb38e7e95b85eac264de"
        },
        "date": 1789306201615,
        "tool": "julia",
        "benches": [
          {
            "name": "Canonical/in-place - 2 internal",
            "value": 205.94740853658536,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":656,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 3 internal",
            "value": 370.5943396226415,
            "unit": "ns",
            "extra": "gctime=0\nmemory=608\nallocs=4\nparams={\"evals\":212,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 4 internal",
            "value": 1789.35,
            "unit": "ns",
            "extra": "gctime=0\nmemory=720\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 5 internal",
            "value": 16571,
            "unit": "ns",
            "extra": "gctime=0\nmemory=29376\nallocs=123\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place mixed - 4 internal",
            "value": 1221.2,
            "unit": "ns",
            "extra": "gctime=0\nmemory=624\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 3 internal",
            "value": 297.81164383561645,
            "unit": "ns",
            "extra": "gctime=0\nmemory=672\nallocs=5\nparams={\"evals\":292,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 4 internal",
            "value": 653.96,
            "unit": "ns",
            "extra": "gctime=0\nmemory=864\nallocs=5\nparams={\"evals\":175,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 5 internal",
            "value": 2847.4444444444443,
            "unit": "ns",
            "extra": "gctime=0\nmemory=976\nallocs=5\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key - 5 internal",
            "value": 5050.857142857143,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11920\nallocs=142\nparams={\"evals\":7,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key mixed - 4 internal",
            "value": 3823.375,
            "unit": "ns",
            "extra": "gctime=0\nmemory=8960\nallocs=110\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key symmetric - 5 internal",
            "value": 3351.8125,
            "unit": "ns",
            "extra": "gctime=0\nmemory=7680\nallocs=77\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 2 internal",
            "value": 1518.8,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3744\nallocs=38\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 3 internal",
            "value": 3759.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=9008\nallocs=83\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 4 internal",
            "value": 14417,
            "unit": "ns",
            "extra": "gctime=0\nmemory=34352\nallocs=282\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 5 internal",
            "value": 82182.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=201296\nallocs=1458\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 2 internal",
            "value": 977.4864864864865,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2224\nallocs=27\nparams={\"evals\":37,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 3 internal",
            "value": 1799.3,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3808\nallocs=48\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 4 internal",
            "value": 5892.666666666667,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11520\nallocs=139\nparams={\"evals\":6,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 5 internal",
            "value": 38361,
            "unit": "ns",
            "extra": "gctime=0\nmemory=78656\nallocs=739\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 4",
            "value": 2806320,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1570056\nallocs=10675\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 4 public",
            "value": 2701254.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1571608\nallocs=10677\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 5",
            "value": 74657035,
            "unit": "ns",
            "extra": "gctime=0\nmemory=12383912\nallocs=61830\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 2 loops",
            "value": 12503,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22384\nallocs=344\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 3 loops",
            "value": 112821,
            "unit": "ns",
            "extra": "gctime=0\nmemory=178544\nallocs=2402\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 4 loops",
            "value": 3121091,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2614368\nallocs=30055\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 5 loops",
            "value": 150070865,
            "unit": "ns",
            "extra": "gctime=17313794\nmemory=255484080\nallocs=3016893\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 2 loops",
            "value": 1413.7,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2336\nallocs=21\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 3 loops",
            "value": 10740,
            "unit": "ns",
            "extra": "gctime=0\nmemory=17648\nallocs=106\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 4 loops",
            "value": 164546,
            "unit": "ns",
            "extra": "gctime=0\nmemory=277264\nallocs=1337\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 5 loops",
            "value": 4812870.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=6349696\nallocs=26462\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 13335,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 113451,
            "unit": "ns",
            "extra": "gctime=0\nmemory=179064\nallocs=2426\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cached",
            "value": 220,
            "unit": "ns",
            "extra": "gctime=0\nmemory=192\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cold",
            "value": 105401.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=336528\nallocs=3021\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/allgraphs production",
            "value": 13044,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/canonical form",
            "value": 203.7176287051482,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":641,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/connected filter",
            "value": 486305,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1114752\nallocs=13755\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/isomorphism reduction",
            "value": 221162,
            "unit": "ns",
            "extra": "gctime=0\nmemory=393856\nallocs=3077\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 3 loops",
            "value": 206905,
            "unit": "ns",
            "extra": "gctime=0\nmemory=411952\nallocs=5355\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 4 loops",
            "value": 1587966,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3021360\nallocs=37806\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 5 loops",
            "value": 13025922,
            "unit": "ns",
            "extra": "gctime=0\nmemory=24594576\nallocs=298664\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
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
          "id": "d5074abdaa993cee477ab5968b528617e8e17ca0",
          "message": "refactor: integrate static weighted-port hardening (#123)",
          "timestamp": "2026-09-13T15:45:42+02:00",
          "tree_id": "7e03784c98c1a7f45706d24f58b9d4ddf4d20729",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/d5074abdaa993cee477ab5968b528617e8e17ca0"
        },
        "date": 1789307518846,
        "tool": "julia",
        "benches": [
          {
            "name": "Canonical/in-place - 2 internal",
            "value": 168.41954707985695,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":839,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 3 internal",
            "value": 312.1900684931507,
            "unit": "ns",
            "extra": "gctime=0\nmemory=608\nallocs=4\nparams={\"evals\":292,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 4 internal",
            "value": 1369,
            "unit": "ns",
            "extra": "gctime=0\nmemory=720\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 5 internal",
            "value": 15738.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=29376\nallocs=123\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place mixed - 4 internal",
            "value": 872.36,
            "unit": "ns",
            "extra": "gctime=0\nmemory=624\nallocs=4\nparams={\"evals\":75,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 3 internal",
            "value": 266.44827586206895,
            "unit": "ns",
            "extra": "gctime=0\nmemory=672\nallocs=5\nparams={\"evals\":464,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 4 internal",
            "value": 557.8429319371728,
            "unit": "ns",
            "extra": "gctime=0\nmemory=864\nallocs=5\nparams={\"evals\":191,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 5 internal",
            "value": 2298.4,
            "unit": "ns",
            "extra": "gctime=0\nmemory=976\nallocs=5\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key - 5 internal",
            "value": 4112.375,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11920\nallocs=142\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key mixed - 4 internal",
            "value": 3089,
            "unit": "ns",
            "extra": "gctime=0\nmemory=8960\nallocs=110\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key symmetric - 5 internal",
            "value": 2818.5555555555557,
            "unit": "ns",
            "extra": "gctime=0\nmemory=7680\nallocs=77\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 2 internal",
            "value": 1288.9,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3744\nallocs=38\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 3 internal",
            "value": 3175.8888888888887,
            "unit": "ns",
            "extra": "gctime=0\nmemory=9008\nallocs=83\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 4 internal",
            "value": 12018,
            "unit": "ns",
            "extra": "gctime=0\nmemory=34352\nallocs=282\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 5 internal",
            "value": 69392,
            "unit": "ns",
            "extra": "gctime=0\nmemory=201296\nallocs=1458\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 2 internal",
            "value": 814.6054421768707,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2224\nallocs=27\nparams={\"evals\":147,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 3 internal",
            "value": 1512.3,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3808\nallocs=48\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 4 internal",
            "value": 4997.285714285715,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11520\nallocs=139\nparams={\"evals\":7,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 5 internal",
            "value": 31446,
            "unit": "ns",
            "extra": "gctime=0\nmemory=78656\nallocs=739\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 4",
            "value": 2281116.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1570056\nallocs=10675\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 4 public",
            "value": 2287160,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1571608\nallocs=10677\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 5",
            "value": 64847534,
            "unit": "ns",
            "extra": "gctime=0\nmemory=12417944\nallocs=61834\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 2 loops",
            "value": 9985,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22384\nallocs=344\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 3 loops",
            "value": 87379,
            "unit": "ns",
            "extra": "gctime=0\nmemory=178544\nallocs=2402\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 4 loops",
            "value": 2655632,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2614368\nallocs=30055\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 5 loops",
            "value": 129332023,
            "unit": "ns",
            "extra": "gctime=21925785.5\nmemory=255484080\nallocs=3016893\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 2 loops",
            "value": 1161.7,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2336\nallocs=21\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 3 loops",
            "value": 8806.333333333334,
            "unit": "ns",
            "extra": "gctime=0\nmemory=17648\nallocs=106\nparams={\"evals\":3,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 4 loops",
            "value": 130352.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=277264\nallocs=1337\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 5 loops",
            "value": 4288998,
            "unit": "ns",
            "extra": "gctime=0\nmemory=6349696\nallocs=26462\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 10956,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 93168,
            "unit": "ns",
            "extra": "gctime=0\nmemory=179064\nallocs=2426\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cached",
            "value": 180,
            "unit": "ns",
            "extra": "gctime=0\nmemory=192\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cold",
            "value": 91114,
            "unit": "ns",
            "extra": "gctime=0\nmemory=336528\nallocs=3021\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/allgraphs production",
            "value": 10696,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/canonical form",
            "value": 170.70212765957447,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":846,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/connected filter",
            "value": 402395,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1114752\nallocs=13755\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/isomorphism reduction",
            "value": 175439,
            "unit": "ns",
            "extra": "gctime=0\nmemory=393856\nallocs=3077\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 3 loops",
            "value": 175349.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=411952\nallocs=5355\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 4 loops",
            "value": 1307513,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3021360\nallocs=37806\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 5 loops",
            "value": 11000936,
            "unit": "ns",
            "extra": "gctime=0\nmemory=24594576\nallocs=298664\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
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
          "id": "6696c9fcf8f24fe864ac40ae907414fe01c73683",
          "message": "release: v0.3.1 (#124)",
          "timestamp": "2026-09-13T15:54:08+02:00",
          "tree_id": "df4ef8e8034e2fd8e03deafc877012163fcb9411",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/6696c9fcf8f24fe864ac40ae907414fe01c73683"
        },
        "date": 1789308041944,
        "tool": "julia",
        "benches": [
          {
            "name": "Canonical/in-place - 2 internal",
            "value": 208.82488479262673,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":651,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 3 internal",
            "value": 385.247619047619,
            "unit": "ns",
            "extra": "gctime=0\nmemory=608\nallocs=4\nparams={\"evals\":210,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 4 internal",
            "value": 1689.1,
            "unit": "ns",
            "extra": "gctime=0\nmemory=720\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 5 internal",
            "value": 18379.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=29376\nallocs=123\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place mixed - 4 internal",
            "value": 1277.4,
            "unit": "ns",
            "extra": "gctime=0\nmemory=624\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 3 internal",
            "value": 299.25441696113074,
            "unit": "ns",
            "extra": "gctime=0\nmemory=672\nallocs=5\nparams={\"evals\":283,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 4 internal",
            "value": 636.3942857142857,
            "unit": "ns",
            "extra": "gctime=0\nmemory=864\nallocs=5\nparams={\"evals\":175,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 5 internal",
            "value": 2832,
            "unit": "ns",
            "extra": "gctime=0\nmemory=976\nallocs=5\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key - 5 internal",
            "value": 5043.714285714285,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11920\nallocs=142\nparams={\"evals\":7,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key mixed - 4 internal",
            "value": 3825.875,
            "unit": "ns",
            "extra": "gctime=0\nmemory=8960\nallocs=110\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key symmetric - 5 internal",
            "value": 3440.1875,
            "unit": "ns",
            "extra": "gctime=0\nmemory=7680\nallocs=77\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 2 internal",
            "value": 1548.9,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3744\nallocs=38\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 3 internal",
            "value": 3770.875,
            "unit": "ns",
            "extra": "gctime=0\nmemory=9008\nallocs=83\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 4 internal",
            "value": 14437,
            "unit": "ns",
            "extra": "gctime=0\nmemory=34352\nallocs=282\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 5 internal",
            "value": 84433.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=201296\nallocs=1458\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 2 internal",
            "value": 963.3859649122807,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2224\nallocs=27\nparams={\"evals\":57,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 3 internal",
            "value": 1776.3,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3808\nallocs=48\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 4 internal",
            "value": 5979.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11520\nallocs=139\nparams={\"evals\":6,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 5 internal",
            "value": 39624,
            "unit": "ns",
            "extra": "gctime=0\nmemory=78656\nallocs=739\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 4",
            "value": 2699736,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1570056\nallocs=10675\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 4 public",
            "value": 2703843,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1571608\nallocs=10677\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 5",
            "value": 73287745.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=12383912\nallocs=61830\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 2 loops",
            "value": 12624,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22384\nallocs=344\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 3 loops",
            "value": 113563,
            "unit": "ns",
            "extra": "gctime=0\nmemory=178544\nallocs=2402\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 4 loops",
            "value": 3113938,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2614368\nallocs=30055\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 5 loops",
            "value": 148658712,
            "unit": "ns",
            "extra": "gctime=18190231.5\nmemory=255484080\nallocs=3016893\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 2 loops",
            "value": 1402.7,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2336\nallocs=21\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 3 loops",
            "value": 11076,
            "unit": "ns",
            "extra": "gctime=0\nmemory=17648\nallocs=106\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 4 loops",
            "value": 165470,
            "unit": "ns",
            "extra": "gctime=0\nmemory=277264\nallocs=1337\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 5 loops",
            "value": 4863146,
            "unit": "ns",
            "extra": "gctime=0\nmemory=6349696\nallocs=26462\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 13105,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 114103.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=179064\nallocs=2426\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cached",
            "value": 230,
            "unit": "ns",
            "extra": "gctime=0\nmemory=192\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cold",
            "value": 105178,
            "unit": "ns",
            "extra": "gctime=0\nmemory=336528\nallocs=3021\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/allgraphs production",
            "value": 13325,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/canonical form",
            "value": 208.66666666666669,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":681,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/connected filter",
            "value": 497714,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1114752\nallocs=13755\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/isomorphism reduction",
            "value": 221109.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=393856\nallocs=3077\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 3 loops",
            "value": 207509,
            "unit": "ns",
            "extra": "gctime=0\nmemory=411952\nallocs=5355\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 4 loops",
            "value": 1575205,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3021360\nallocs=37806\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 5 loops",
            "value": 13044053,
            "unit": "ns",
            "extra": "gctime=0\nmemory=24594576\nallocs=298664\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
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
          "id": "dd9c0eb8a6cbbe33e691f50b1cd6a3b25ba6fadc",
          "message": "feat: add explicit degree-sequence multigraph problems (#127)",
          "timestamp": "2026-09-13T17:06:03+02:00",
          "tree_id": "f09bee09b5304744c440aaf5777178828f16d59e",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/dd9c0eb8a6cbbe33e691f50b1cd6a3b25ba6fadc"
        },
        "date": 1789312365852,
        "tool": "julia",
        "benches": [
          {
            "name": "Canonical/in-place - 2 internal",
            "value": 215.12220566318928,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":671,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 3 internal",
            "value": 400.6048780487805,
            "unit": "ns",
            "extra": "gctime=0\nmemory=608\nallocs=4\nparams={\"evals\":205,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 4 internal",
            "value": 1727.6,
            "unit": "ns",
            "extra": "gctime=0\nmemory=720\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 5 internal",
            "value": 18357.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=29376\nallocs=123\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place mixed - 4 internal",
            "value": 1304,
            "unit": "ns",
            "extra": "gctime=0\nmemory=624\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 3 internal",
            "value": 338.15686274509807,
            "unit": "ns",
            "extra": "gctime=0\nmemory=672\nallocs=5\nparams={\"evals\":255,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 4 internal",
            "value": 705.7798742138365,
            "unit": "ns",
            "extra": "gctime=0\nmemory=864\nallocs=5\nparams={\"evals\":159,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 5 internal",
            "value": 2980,
            "unit": "ns",
            "extra": "gctime=0\nmemory=976\nallocs=5\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key - 5 internal",
            "value": 5139.142857142857,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11920\nallocs=142\nparams={\"evals\":7,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key mixed - 4 internal",
            "value": 3844.625,
            "unit": "ns",
            "extra": "gctime=0\nmemory=8960\nallocs=110\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key symmetric - 5 internal",
            "value": 3554.125,
            "unit": "ns",
            "extra": "gctime=0\nmemory=7680\nallocs=77\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 2 internal",
            "value": 1587.4,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3744\nallocs=38\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 3 internal",
            "value": 3954.75,
            "unit": "ns",
            "extra": "gctime=0\nmemory=9008\nallocs=83\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 4 internal",
            "value": 15233,
            "unit": "ns",
            "extra": "gctime=0\nmemory=34352\nallocs=282\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 5 internal",
            "value": 86531,
            "unit": "ns",
            "extra": "gctime=0\nmemory=201296\nallocs=1458\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 2 internal",
            "value": 994.7142857142857,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2224\nallocs=27\nparams={\"evals\":28,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 3 internal",
            "value": 1866.9,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3808\nallocs=48\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 4 internal",
            "value": 6241,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11520\nallocs=139\nparams={\"evals\":6,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 5 internal",
            "value": 39270,
            "unit": "ns",
            "extra": "gctime=0\nmemory=78656\nallocs=739\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 4",
            "value": 2879869,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1570056\nallocs=10675\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 4 public",
            "value": 2880598,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1571608\nallocs=10677\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 5",
            "value": 79989127,
            "unit": "ns",
            "extra": "gctime=0\nmemory=12519368\nallocs=61835\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 2 loops",
            "value": 12829,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22384\nallocs=344\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 3 loops",
            "value": 111348,
            "unit": "ns",
            "extra": "gctime=0\nmemory=178544\nallocs=2402\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 4 loops",
            "value": 3378095,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2614368\nallocs=30055\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 5 loops",
            "value": 161365796,
            "unit": "ns",
            "extra": "gctime=24294149\nmemory=255484080\nallocs=3016893\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 2 loops",
            "value": 1495.3,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2336\nallocs=21\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 3 loops",
            "value": 11237,
            "unit": "ns",
            "extra": "gctime=0\nmemory=17648\nallocs=106\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 4 loops",
            "value": 169931,
            "unit": "ns",
            "extra": "gctime=0\nmemory=277264\nallocs=1337\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 5 loops",
            "value": 5256014.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=6349696\nallocs=26462\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 13410,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 111728,
            "unit": "ns",
            "extra": "gctime=0\nmemory=179064\nallocs=2426\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cached",
            "value": 220,
            "unit": "ns",
            "extra": "gctime=0\nmemory=192\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cold",
            "value": 115344,
            "unit": "ns",
            "extra": "gctime=0\nmemory=336528\nallocs=3021\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/allgraphs production",
            "value": 13520.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/canonical form",
            "value": 216.09001512859305,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":661,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/connected filter",
            "value": 503324.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1114752\nallocs=13755\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/isomorphism reduction",
            "value": 226962.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=393856\nallocs=3077\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 3 loops",
            "value": 213102,
            "unit": "ns",
            "extra": "gctime=0\nmemory=411952\nallocs=5355\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 4 loops",
            "value": 1602401,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3021360\nallocs=37806\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 5 loops",
            "value": 13537059,
            "unit": "ns",
            "extra": "gctime=0\nmemory=24594576\nallocs=298664\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
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
          "id": "4b00b2633e2abc97df65c8276cf66e20f2475156",
          "message": "refactor: share problem-preserving relabeling groups (#130)\n\n* refactor: extract generic problem-preserving relabeling groups\n\n* style: apply JuliaFormatter to relabeling helper\n\n* style: apply JuliaFormatter to relabeling tests",
          "timestamp": "2026-09-13T17:24:43+02:00",
          "tree_id": "d1a96f3bdf7bd0ea7ad90aeb154a8d09ad81e664",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/4b00b2633e2abc97df65c8276cf66e20f2475156"
        },
        "date": 1789313461614,
        "tool": "julia",
        "benches": [
          {
            "name": "Canonical/in-place - 2 internal",
            "value": 167.73000000000002,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":800,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 3 internal",
            "value": 308.90344827586205,
            "unit": "ns",
            "extra": "gctime=0\nmemory=608\nallocs=4\nparams={\"evals\":290,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 4 internal",
            "value": 1325,
            "unit": "ns",
            "extra": "gctime=0\nmemory=720\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 5 internal",
            "value": 15262.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=29376\nallocs=123\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place mixed - 4 internal",
            "value": 869.7364864864865,
            "unit": "ns",
            "extra": "gctime=0\nmemory=624\nallocs=4\nparams={\"evals\":74,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 3 internal",
            "value": 259.11206896551727,
            "unit": "ns",
            "extra": "gctime=0\nmemory=672\nallocs=5\nparams={\"evals\":464,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 4 internal",
            "value": 550.8678756476684,
            "unit": "ns",
            "extra": "gctime=0\nmemory=864\nallocs=5\nparams={\"evals\":193,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 5 internal",
            "value": 2280.8500000000004,
            "unit": "ns",
            "extra": "gctime=0\nmemory=976\nallocs=5\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key - 5 internal",
            "value": 4141.125,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11920\nallocs=142\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key mixed - 4 internal",
            "value": 3090.1111111111113,
            "unit": "ns",
            "extra": "gctime=0\nmemory=8960\nallocs=110\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key symmetric - 5 internal",
            "value": 2796.3333333333335,
            "unit": "ns",
            "extra": "gctime=0\nmemory=7680\nallocs=77\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 2 internal",
            "value": 1247.9,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3744\nallocs=38\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 3 internal",
            "value": 3097.9444444444443,
            "unit": "ns",
            "extra": "gctime=0\nmemory=9008\nallocs=83\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 4 internal",
            "value": 11728,
            "unit": "ns",
            "extra": "gctime=0\nmemory=34352\nallocs=282\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 5 internal",
            "value": 68261,
            "unit": "ns",
            "extra": "gctime=0\nmemory=201296\nallocs=1458\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 2 internal",
            "value": 809.0853658536586,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2224\nallocs=27\nparams={\"evals\":123,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 3 internal",
            "value": 1502.2,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3808\nallocs=48\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 4 internal",
            "value": 4925.857142857143,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11520\nallocs=139\nparams={\"evals\":7,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 5 internal",
            "value": 31567,
            "unit": "ns",
            "extra": "gctime=0\nmemory=78656\nallocs=739\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 4",
            "value": 2222904,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1570056\nallocs=10675\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 4 public",
            "value": 2228171,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1571608\nallocs=10677\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 5",
            "value": 62094118.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=12519368\nallocs=61835\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 2 loops",
            "value": 10044,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22384\nallocs=344\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 3 loops",
            "value": 87310,
            "unit": "ns",
            "extra": "gctime=0\nmemory=178544\nallocs=2402\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 4 loops",
            "value": 2620826.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2614368\nallocs=30055\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 5 loops",
            "value": 128451166,
            "unit": "ns",
            "extra": "gctime=21440399\nmemory=255484080\nallocs=3016893\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 2 loops",
            "value": 1161.8,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2336\nallocs=21\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 3 loops",
            "value": 8836.333333333334,
            "unit": "ns",
            "extra": "gctime=0\nmemory=17648\nallocs=106\nparams={\"evals\":3,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 4 loops",
            "value": 134710,
            "unit": "ns",
            "extra": "gctime=0\nmemory=277264\nallocs=1337\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 5 loops",
            "value": 4087551,
            "unit": "ns",
            "extra": "gctime=0\nmemory=6349696\nallocs=26462\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 10645,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 88856.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=179064\nallocs=2426\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cached",
            "value": 180,
            "unit": "ns",
            "extra": "gctime=0\nmemory=192\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cold",
            "value": 90539.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=336528\nallocs=3021\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/allgraphs production",
            "value": 10696,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/canonical form",
            "value": 166.92550505050505,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":792,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/connected filter",
            "value": 391911,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1114752\nallocs=13755\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/isomorphism reduction",
            "value": 173497,
            "unit": "ns",
            "extra": "gctime=0\nmemory=393856\nallocs=3077\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 3 loops",
            "value": 172225.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=411952\nallocs=5355\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 4 loops",
            "value": 1280117,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3021360\nallocs=37806\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 5 loops",
            "value": 10701744.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=24594576\nallocs=298664\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
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
          "id": "7d08a021196cf2cff32c42223084cca22481d100",
          "message": "feat: add exact typed undirected multigraph problems",
          "timestamp": "2026-09-13T19:00:26+02:00",
          "tree_id": "94c84364362d3c994528b9ae87ec44119190fb20",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/7d08a021196cf2cff32c42223084cca22481d100"
        },
        "date": 1789319214231,
        "tool": "julia",
        "benches": [
          {
            "name": "Canonical/in-place - 2 internal",
            "value": 202.0503546099291,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":705,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 3 internal",
            "value": 363.4697674418605,
            "unit": "ns",
            "extra": "gctime=0\nmemory=608\nallocs=4\nparams={\"evals\":215,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 4 internal",
            "value": 1498.8,
            "unit": "ns",
            "extra": "gctime=0\nmemory=720\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 5 internal",
            "value": 17202,
            "unit": "ns",
            "extra": "gctime=0\nmemory=29376\nallocs=123\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place mixed - 4 internal",
            "value": 1209.3,
            "unit": "ns",
            "extra": "gctime=0\nmemory=624\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 3 internal",
            "value": 297.0387096774194,
            "unit": "ns",
            "extra": "gctime=0\nmemory=672\nallocs=5\nparams={\"evals\":310,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 4 internal",
            "value": 658.3197674418604,
            "unit": "ns",
            "extra": "gctime=0\nmemory=864\nallocs=5\nparams={\"evals\":172,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 5 internal",
            "value": 2876.4444444444443,
            "unit": "ns",
            "extra": "gctime=0\nmemory=976\nallocs=5\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key - 5 internal",
            "value": 4923.428571428572,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11920\nallocs=142\nparams={\"evals\":7,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key mixed - 4 internal",
            "value": 3729.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=8960\nallocs=110\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key symmetric - 5 internal",
            "value": 3333.625,
            "unit": "ns",
            "extra": "gctime=0\nmemory=7680\nallocs=77\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 2 internal",
            "value": 1506.8,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3744\nallocs=38\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 3 internal",
            "value": 3655.625,
            "unit": "ns",
            "extra": "gctime=0\nmemory=9008\nallocs=83\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 4 internal",
            "value": 14536.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=34352\nallocs=282\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 5 internal",
            "value": 82103,
            "unit": "ns",
            "extra": "gctime=0\nmemory=201296\nallocs=1458\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 2 internal",
            "value": 977.625,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2224\nallocs=27\nparams={\"evals\":56,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 3 internal",
            "value": 1855.4,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3808\nallocs=48\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 4 internal",
            "value": 6003,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11520\nallocs=139\nparams={\"evals\":6,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 5 internal",
            "value": 39513,
            "unit": "ns",
            "extra": "gctime=0\nmemory=78656\nallocs=739\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 4",
            "value": 2695887.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1570056\nallocs=10675\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 4 public",
            "value": 2689132,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1571608\nallocs=10677\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 5",
            "value": 74286250.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=12519368\nallocs=61835\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 2 loops",
            "value": 12484,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22384\nallocs=344\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 3 loops",
            "value": 112394.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=178544\nallocs=2402\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 4 loops",
            "value": 3142346,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2614368\nallocs=30055\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 5 loops",
            "value": 147688632,
            "unit": "ns",
            "extra": "gctime=17600863.5\nmemory=255484080\nallocs=3016893\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 2 loops",
            "value": 1405.6,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2336\nallocs=21\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 3 loops",
            "value": 10995.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=17648\nallocs=106\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 4 loops",
            "value": 161170.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=277264\nallocs=1337\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 5 loops",
            "value": 4692304,
            "unit": "ns",
            "extra": "gctime=0\nmemory=6349696\nallocs=26462\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 13385,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 113812,
            "unit": "ns",
            "extra": "gctime=0\nmemory=179064\nallocs=2426\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cached",
            "value": 211,
            "unit": "ns",
            "extra": "gctime=0\nmemory=192\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cold",
            "value": 103092,
            "unit": "ns",
            "extra": "gctime=0\nmemory=336528\nallocs=3021\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/allgraphs production",
            "value": 13154,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/canonical form",
            "value": 202.92482269503546,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":705,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/connected filter",
            "value": 488294.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1114752\nallocs=13755\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/isomorphism reduction",
            "value": 215812.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=393856\nallocs=3077\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 3 loops",
            "value": 207426.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=411952\nallocs=5355\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 4 loops",
            "value": 1563714,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3021360\nallocs=37806\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 5 loops",
            "value": 12988667,
            "unit": "ns",
            "extra": "gctime=0\nmemory=24594576\nallocs=298664\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
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
          "id": "795cb443e17047d58cac2eae994ab801b4b01241",
          "message": "perf: use multiplicity-matrix canonicalization for typed graphs",
          "timestamp": "2026-09-13T20:04:20+02:00",
          "tree_id": "9a794188b7b9edb84afc6078d3051c7c662d3225",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/795cb443e17047d58cac2eae994ab801b4b01241"
        },
        "date": 1789323077851,
        "tool": "julia",
        "benches": [
          {
            "name": "Canonical/in-place - 2 internal",
            "value": 199.81296572280178,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":671,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 3 internal",
            "value": 372.6121495327103,
            "unit": "ns",
            "extra": "gctime=0\nmemory=608\nallocs=4\nparams={\"evals\":214,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 4 internal",
            "value": 1793.4,
            "unit": "ns",
            "extra": "gctime=0\nmemory=720\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 5 internal",
            "value": 16215.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=29376\nallocs=123\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place mixed - 4 internal",
            "value": 1228.3,
            "unit": "ns",
            "extra": "gctime=0\nmemory=624\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 3 internal",
            "value": 314.7116788321168,
            "unit": "ns",
            "extra": "gctime=0\nmemory=672\nallocs=5\nparams={\"evals\":274,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 4 internal",
            "value": 668.1169590643275,
            "unit": "ns",
            "extra": "gctime=0\nmemory=864\nallocs=5\nparams={\"evals\":171,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 5 internal",
            "value": 2694,
            "unit": "ns",
            "extra": "gctime=0\nmemory=976\nallocs=5\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key - 5 internal",
            "value": 5009.357142857143,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11920\nallocs=142\nparams={\"evals\":7,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key mixed - 4 internal",
            "value": 3768.25,
            "unit": "ns",
            "extra": "gctime=0\nmemory=8960\nallocs=110\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key symmetric - 5 internal",
            "value": 3368.75,
            "unit": "ns",
            "extra": "gctime=0\nmemory=7680\nallocs=77\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 2 internal",
            "value": 1495.8,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3744\nallocs=38\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 3 internal",
            "value": 3708.125,
            "unit": "ns",
            "extra": "gctime=0\nmemory=9008\nallocs=83\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 4 internal",
            "value": 14457,
            "unit": "ns",
            "extra": "gctime=0\nmemory=34352\nallocs=282\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 5 internal",
            "value": 83575.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=201296\nallocs=1458\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 2 internal",
            "value": 953.4745762711865,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2224\nallocs=27\nparams={\"evals\":59,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 3 internal",
            "value": 1761.3,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3808\nallocs=48\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 4 internal",
            "value": 5944.333333333333,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11520\nallocs=139\nparams={\"evals\":6,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 5 internal",
            "value": 39534,
            "unit": "ns",
            "extra": "gctime=0\nmemory=78656\nallocs=739\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 4",
            "value": 2664252,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1570056\nallocs=10675\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 4 public",
            "value": 2667638,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1571608\nallocs=10677\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 5",
            "value": 73105907.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=12417944\nallocs=61834\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 2 loops",
            "value": 12553,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22384\nallocs=344\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 3 loops",
            "value": 112609.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=178544\nallocs=2402\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 4 loops",
            "value": 3090185,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2614368\nallocs=30055\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 5 loops",
            "value": 145614432,
            "unit": "ns",
            "extra": "gctime=17140814\nmemory=255484080\nallocs=3016893\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 2 loops",
            "value": 1401.6,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2336\nallocs=21\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 3 loops",
            "value": 10971,
            "unit": "ns",
            "extra": "gctime=0\nmemory=17648\nallocs=106\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 4 loops",
            "value": 161505.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=277264\nallocs=1337\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 5 loops",
            "value": 4218787.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=6349696\nallocs=26462\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 13325,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 113080,
            "unit": "ns",
            "extra": "gctime=0\nmemory=179064\nallocs=2426\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cached",
            "value": 211,
            "unit": "ns",
            "extra": "gctime=0\nmemory=192\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cold",
            "value": 104805.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=336528\nallocs=3021\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/allgraphs production",
            "value": 13235,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/canonical form",
            "value": 200.98985507246377,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":690,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/connected filter",
            "value": 488795,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1114752\nallocs=13755\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/isomorphism reduction",
            "value": 221432.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=393856\nallocs=3077\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 3 loops",
            "value": 208649,
            "unit": "ns",
            "extra": "gctime=0\nmemory=411952\nallocs=5355\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 4 loops",
            "value": 1563822,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3021360\nallocs=37806\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 5 loops",
            "value": 12892502.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=24594576\nallocs=298664\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/canonicalize cycle n6 edge-list",
            "value": 24716,
            "unit": "ns",
            "extra": "gctime=0\nmemory=320\nallocs=2\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/canonicalize cycle n6 matrix",
            "value": 13084,
            "unit": "ns",
            "extra": "gctime=0\nmemory=752\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/construct loopless n6",
            "value": 199551,
            "unit": "ns",
            "extra": "gctime=0\nmemory=266560\nallocs=2911\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/generate loopless n5",
            "value": 64490,
            "unit": "ns",
            "extra": "gctime=0\nmemory=51280\nallocs=592\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
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
          "id": "b1928bd00ef9d960775565e124808c8b58965766",
          "message": "perf: optimize typed problem metadata normalization (#136)\n\nExact lexicographic prefix refinement for TypedMultigraphProblem metadata normalization, preserving the legacy canonical representation contract while eliminating eager full-orbit materialization.\n\nCloses #135.",
          "timestamp": "2026-09-13T22:30:53+02:00",
          "tree_id": "5079931ff97f880cad97e1c3d621f43c1d16c11b",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/b1928bd00ef9d960775565e124808c8b58965766"
        },
        "date": 1789331883919,
        "tool": "julia",
        "benches": [
          {
            "name": "Canonical/in-place - 2 internal",
            "value": 200.9600614439324,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":651,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 3 internal",
            "value": 371.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=608\nallocs=4\nparams={\"evals\":212,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 4 internal",
            "value": 1777.85,
            "unit": "ns",
            "extra": "gctime=0\nmemory=720\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 5 internal",
            "value": 17162,
            "unit": "ns",
            "extra": "gctime=0\nmemory=29376\nallocs=123\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place mixed - 4 internal",
            "value": 1237.3,
            "unit": "ns",
            "extra": "gctime=0\nmemory=624\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 3 internal",
            "value": 313.4855072463768,
            "unit": "ns",
            "extra": "gctime=0\nmemory=672\nallocs=5\nparams={\"evals\":276,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 4 internal",
            "value": 661.679411764706,
            "unit": "ns",
            "extra": "gctime=0\nmemory=864\nallocs=5\nparams={\"evals\":170,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 5 internal",
            "value": 2879.8888888888887,
            "unit": "ns",
            "extra": "gctime=0\nmemory=976\nallocs=5\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key - 5 internal",
            "value": 4995.142857142857,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11920\nallocs=142\nparams={\"evals\":7,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key mixed - 4 internal",
            "value": 3768.3125,
            "unit": "ns",
            "extra": "gctime=0\nmemory=8960\nallocs=110\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key symmetric - 5 internal",
            "value": 3337.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=7680\nallocs=77\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 2 internal",
            "value": 1535.9,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3744\nallocs=38\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 3 internal",
            "value": 3659.375,
            "unit": "ns",
            "extra": "gctime=0\nmemory=9008\nallocs=83\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 4 internal",
            "value": 14397,
            "unit": "ns",
            "extra": "gctime=0\nmemory=34352\nallocs=282\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 5 internal",
            "value": 84549,
            "unit": "ns",
            "extra": "gctime=0\nmemory=201296\nallocs=1458\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 2 internal",
            "value": 966.811475409836,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2224\nallocs=27\nparams={\"evals\":61,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 3 internal",
            "value": 1782.3,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3808\nallocs=48\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 4 internal",
            "value": 5802.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11520\nallocs=139\nparams={\"evals\":6,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 5 internal",
            "value": 39363,
            "unit": "ns",
            "extra": "gctime=0\nmemory=78656\nallocs=739\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 4",
            "value": 2708387.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1570056\nallocs=10675\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 4 public",
            "value": 2707875,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1571608\nallocs=10677\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 5",
            "value": 74365832,
            "unit": "ns",
            "extra": "gctime=0\nmemory=12383912\nallocs=61830\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 2 loops",
            "value": 12453,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22384\nallocs=344\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 3 loops",
            "value": 111610,
            "unit": "ns",
            "extra": "gctime=0\nmemory=178544\nallocs=2402\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 4 loops",
            "value": 3092567,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2614368\nallocs=30055\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 5 loops",
            "value": 147359440,
            "unit": "ns",
            "extra": "gctime=17936905\nmemory=255484080\nallocs=3016893\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 2 loops",
            "value": 1396.6,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2336\nallocs=21\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 3 loops",
            "value": 10930,
            "unit": "ns",
            "extra": "gctime=0\nmemory=17648\nallocs=106\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 4 loops",
            "value": 163727,
            "unit": "ns",
            "extra": "gctime=0\nmemory=277264\nallocs=1337\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 5 loops",
            "value": 4818241,
            "unit": "ns",
            "extra": "gctime=0\nmemory=6349696\nallocs=26462\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 13205,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 112400,
            "unit": "ns",
            "extra": "gctime=0\nmemory=179064\nallocs=2426\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cached",
            "value": 230,
            "unit": "ns",
            "extra": "gctime=0\nmemory=192\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cold",
            "value": 104405,
            "unit": "ns",
            "extra": "gctime=0\nmemory=336528\nallocs=3021\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/allgraphs production",
            "value": 13125,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/canonical form",
            "value": 203.7645305514158,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":671,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/connected filter",
            "value": 489327,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1114752\nallocs=13755\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/isomorphism reduction",
            "value": 217443,
            "unit": "ns",
            "extra": "gctime=0\nmemory=393856\nallocs=3077\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 3 loops",
            "value": 207460,
            "unit": "ns",
            "extra": "gctime=0\nmemory=411952\nallocs=5355\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 4 loops",
            "value": 1559464.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3021360\nallocs=37806\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 5 loops",
            "value": 13002808.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=24594576\nallocs=298664\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/canonicalize cycle n6 edge-list",
            "value": 24516,
            "unit": "ns",
            "extra": "gctime=0\nmemory=320\nallocs=2\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/canonicalize cycle n6 matrix",
            "value": 12965,
            "unit": "ns",
            "extra": "gctime=0\nmemory=752\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/construct admissibility-refined n6",
            "value": 47419.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=105904\nallocs=1495\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/construct degree-split n6",
            "value": 3365.0625,
            "unit": "ns",
            "extra": "gctime=0\nmemory=7504\nallocs=99\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/construct loopless n6",
            "value": 2792,
            "unit": "ns",
            "extra": "gctime=0\nmemory=5488\nallocs=71\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/construct mixed-color n6",
            "value": 3877.25,
            "unit": "ns",
            "extra": "gctime=0\nmemory=9008\nallocs=117\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/generate loopless n5",
            "value": 64170,
            "unit": "ns",
            "extra": "gctime=0\nmemory=51280\nallocs=592\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
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
          "id": "6f7964b7642ebe80f81d16fdc434b1eb89fba785",
          "message": "perf: add native typed continuation-state engine (#146)\n\nImplements the complete typed continuation-state optimization track from #139/#142 as one cumulative production change.\n\nIncludes the exact native continuation-state engine, precomputed relabeling actions, lossless packed canonical keys, mutable triangular multiplicity recursion, production crossover selection, and the certified scalar canonicalizer repair.\n\nSupersedes implementation tranches #140, #143, and #145.",
          "timestamp": "2026-09-14T13:20:53+02:00",
          "tree_id": "50a3c32dcc8c8b7db24060abc8bc6ee741643f10",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/6f7964b7642ebe80f81d16fdc434b1eb89fba785"
        },
        "date": 1789385388239,
        "tool": "julia",
        "benches": [
          {
            "name": "Canonical/in-place - 2 internal",
            "value": 169.55780691299165,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":839,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 3 internal",
            "value": 312.36749116607774,
            "unit": "ns",
            "extra": "gctime=0\nmemory=608\nallocs=4\nparams={\"evals\":283,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 4 internal",
            "value": 1335,
            "unit": "ns",
            "extra": "gctime=0\nmemory=720\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 5 internal",
            "value": 7415.75,
            "unit": "ns",
            "extra": "gctime=0\nmemory=816\nallocs=4\nparams={\"evals\":4,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place mixed - 4 internal",
            "value": 866.3417721518987,
            "unit": "ns",
            "extra": "gctime=0\nmemory=624\nallocs=4\nparams={\"evals\":79,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 3 internal",
            "value": 261.88137472283813,
            "unit": "ns",
            "extra": "gctime=0\nmemory=672\nallocs=5\nparams={\"evals\":451,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 4 internal",
            "value": 549.8238341968912,
            "unit": "ns",
            "extra": "gctime=0\nmemory=864\nallocs=5\nparams={\"evals\":193,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 5 internal",
            "value": 2280.3,
            "unit": "ns",
            "extra": "gctime=0\nmemory=976\nallocs=5\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key - 5 internal",
            "value": 4099.75,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11920\nallocs=142\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key mixed - 4 internal",
            "value": 3091.222222222222,
            "unit": "ns",
            "extra": "gctime=0\nmemory=8960\nallocs=110\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key symmetric - 5 internal",
            "value": 2824.1111111111113,
            "unit": "ns",
            "extra": "gctime=0\nmemory=7680\nallocs=77\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 2 internal",
            "value": 1301.9,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3744\nallocs=38\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 3 internal",
            "value": 3169.1111111111113,
            "unit": "ns",
            "extra": "gctime=0\nmemory=9008\nallocs=83\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 4 internal",
            "value": 12228,
            "unit": "ns",
            "extra": "gctime=0\nmemory=34352\nallocs=282\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 5 internal",
            "value": 69923,
            "unit": "ns",
            "extra": "gctime=0\nmemory=201296\nallocs=1458\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 2 internal",
            "value": 816.4568965517242,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2224\nallocs=27\nparams={\"evals\":116,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 3 internal",
            "value": 1500.2,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3808\nallocs=48\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 4 internal",
            "value": 5003,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11520\nallocs=139\nparams={\"evals\":7,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 5 internal",
            "value": 31617,
            "unit": "ns",
            "extra": "gctime=0\nmemory=78656\nallocs=739\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 4",
            "value": 2232503.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1570056\nallocs=10675\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 4 public",
            "value": 2240275,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1571608\nallocs=10677\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 5",
            "value": 62639937,
            "unit": "ns",
            "extra": "gctime=0\nmemory=12383912\nallocs=61830\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 2 loops",
            "value": 10305,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22384\nallocs=344\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 3 loops",
            "value": 87920,
            "unit": "ns",
            "extra": "gctime=0\nmemory=178544\nallocs=2402\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 4 loops",
            "value": 2650496,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2614368\nallocs=30055\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 5 loops",
            "value": 128917006,
            "unit": "ns",
            "extra": "gctime=22371504\nmemory=250547760\nallocs=2996325\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 2 loops",
            "value": 1218.8,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2336\nallocs=21\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 3 loops",
            "value": 8910,
            "unit": "ns",
            "extra": "gctime=0\nmemory=17648\nallocs=106\nparams={\"evals\":3,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 4 loops",
            "value": 132219.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=277264\nallocs=1337\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 5 loops",
            "value": 4229791,
            "unit": "ns",
            "extra": "gctime=0\nmemory=6349696\nallocs=26462\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 10806,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 89092,
            "unit": "ns",
            "extra": "gctime=0\nmemory=179064\nallocs=2426\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cached",
            "value": 170,
            "unit": "ns",
            "extra": "gctime=0\nmemory=192\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cold",
            "value": 93358,
            "unit": "ns",
            "extra": "gctime=0\nmemory=336528\nallocs=3021\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/allgraphs production",
            "value": 10646,
            "unit": "ns",
            "extra": "gctime=0\nmemory=22904\nallocs=368\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/canonical form",
            "value": 172.994019138756,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":836,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/connected filter",
            "value": 408411,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1114752\nallocs=13755\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/isomorphism reduction",
            "value": 190165,
            "unit": "ns",
            "extra": "gctime=0\nmemory=393856\nallocs=3077\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 3 loops",
            "value": 174386.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=411952\nallocs=5355\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 4 loops",
            "value": 1302546,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3021360\nallocs=37806\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 5 loops",
            "value": 10959668.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=24594576\nallocs=298664\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/bipartite n8 native",
            "value": 332849,
            "unit": "ns",
            "extra": "gctime=0\nmemory=360896\nallocs=1434\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/bipartite n8 packed",
            "value": 341442,
            "unit": "ns",
            "extra": "gctime=0\nmemory=387232\nallocs=1507\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/bipartite n8 production",
            "value": 333070,
            "unit": "ns",
            "extra": "gctime=0\nmemory=360896\nallocs=1434\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/bipartite n8 row-reduced",
            "value": 347215.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=396032\nallocs=1574\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/fixed species n6 native",
            "value": 25147,
            "unit": "ns",
            "extra": "gctime=0\nmemory=38288\nallocs=559\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/fixed species n6 packed",
            "value": 29503,
            "unit": "ns",
            "extra": "gctime=0\nmemory=53952\nallocs=630\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/fixed species n6 production",
            "value": 25076,
            "unit": "ns",
            "extra": "gctime=0\nmemory=38288\nallocs=559\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/fixed species n6 row-reduced",
            "value": 31386,
            "unit": "ns",
            "extra": "gctime=0\nmemory=59248\nallocs=688\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/identity group n6 native",
            "value": 236147.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=338880\nallocs=5599\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/identity group n6 production",
            "value": 176069,
            "unit": "ns",
            "extra": "gctime=0\nmemory=330336\nallocs=5756\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/loop subset n6 native",
            "value": 70073,
            "unit": "ns",
            "extra": "gctime=0\nmemory=59424\nallocs=658\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/loop subset n6 packed",
            "value": 79978,
            "unit": "ns",
            "extra": "gctime=0\nmemory=97488\nallocs=829\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/loop subset n6 production",
            "value": 69622,
            "unit": "ns",
            "extra": "gctime=0\nmemory=59424\nallocs=658\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/loop subset n6 row-reduced",
            "value": 84825,
            "unit": "ns",
            "extra": "gctime=0\nmemory=113840\nallocs=980\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/canonicalize cycle n6 edge-list",
            "value": 19859,
            "unit": "ns",
            "extra": "gctime=0\nmemory=320\nallocs=2\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/canonicalize cycle n6 matrix",
            "value": 9223,
            "unit": "ns",
            "extra": "gctime=0\nmemory=752\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/canonicalize cycle n6 triangular",
            "value": 5017.428571428572,
            "unit": "ns",
            "extra": "gctime=0\nmemory=384\nallocs=2\nparams={\"evals\":7,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/construct admissibility-refined n6",
            "value": 36834,
            "unit": "ns",
            "extra": "gctime=0\nmemory=105904\nallocs=1495\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/construct degree-split n6",
            "value": 2788.5555555555557,
            "unit": "ns",
            "extra": "gctime=0\nmemory=7504\nallocs=99\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/construct loopless n6",
            "value": 2308.9444444444443,
            "unit": "ns",
            "extra": "gctime=0\nmemory=5488\nallocs=71\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/construct mixed-color n6",
            "value": 3218.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=9008\nallocs=117\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/generate loopless n5",
            "value": 32197,
            "unit": "ns",
            "extra": "gctime=0\nmemory=51584\nallocs=384\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
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
          "id": "8df3b46a72126a9d8ac09650be6227cb67b50a6d",
          "message": "refactor: make graph interoperability optional (#147)\n\nMove Graphs.jl to optional extension interoperability, remove Multigraphs/DocStringExtensions from the core dependency surface, add the native GCGraph representation and native connectivity kernel, and preserve the certified typed-engine performance/type-stability contract.\n\nSupersedes the standalone connectivity implementation in #141.",
          "timestamp": "2026-09-14T13:33:16+02:00",
          "tree_id": "c3869d6f0c7db8afecd36e65b757365e468ca9e0",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/8df3b46a72126a9d8ac09650be6227cb67b50a6d"
        },
        "date": 1789386114768,
        "tool": "julia",
        "benches": [
          {
            "name": "Canonical/in-place - 2 internal",
            "value": 170.19736842105263,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":836,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 3 internal",
            "value": 311.73333333333335,
            "unit": "ns",
            "extra": "gctime=0\nmemory=608\nallocs=4\nparams={\"evals\":285,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 4 internal",
            "value": 1323,
            "unit": "ns",
            "extra": "gctime=0\nmemory=720\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 5 internal",
            "value": 7291,
            "unit": "ns",
            "extra": "gctime=0\nmemory=816\nallocs=4\nparams={\"evals\":4,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place mixed - 4 internal",
            "value": 870.6666666666666,
            "unit": "ns",
            "extra": "gctime=0\nmemory=624\nallocs=4\nparams={\"evals\":78,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 3 internal",
            "value": 272.9186813186813,
            "unit": "ns",
            "extra": "gctime=0\nmemory=672\nallocs=5\nparams={\"evals\":455,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 4 internal",
            "value": 543.0386597938144,
            "unit": "ns",
            "extra": "gctime=0\nmemory=864\nallocs=5\nparams={\"evals\":194,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 5 internal",
            "value": 2251.4,
            "unit": "ns",
            "extra": "gctime=0\nmemory=976\nallocs=5\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key - 5 internal",
            "value": 4082.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11920\nallocs=142\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key mixed - 4 internal",
            "value": 3054.6666666666665,
            "unit": "ns",
            "extra": "gctime=0\nmemory=8960\nallocs=110\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key symmetric - 5 internal",
            "value": 2805.3333333333335,
            "unit": "ns",
            "extra": "gctime=0\nmemory=7680\nallocs=77\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 2 internal",
            "value": 1288.9,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3744\nallocs=38\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 3 internal",
            "value": 3113.5555555555557,
            "unit": "ns",
            "extra": "gctime=0\nmemory=9008\nallocs=83\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 4 internal",
            "value": 11818,
            "unit": "ns",
            "extra": "gctime=0\nmemory=34352\nallocs=282\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 5 internal",
            "value": 68604,
            "unit": "ns",
            "extra": "gctime=0\nmemory=201296\nallocs=1458\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 2 internal",
            "value": 803.9664429530201,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2224\nallocs=27\nparams={\"evals\":149,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 3 internal",
            "value": 1476.2,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3808\nallocs=48\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 4 internal",
            "value": 4864.428571428572,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11520\nallocs=139\nparams={\"evals\":7,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 5 internal",
            "value": 30656,
            "unit": "ns",
            "extra": "gctime=0\nmemory=78656\nallocs=739\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 4",
            "value": 2199452,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1570056\nallocs=10675\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 4 public",
            "value": 2197223.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1571608\nallocs=10677\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 5",
            "value": 61065515,
            "unit": "ns",
            "extra": "gctime=0\nmemory=12519368\nallocs=61835\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Connectivity/Graphs adapter connected",
            "value": 276.3443113772455,
            "unit": "ns",
            "extra": "gctime=0\nmemory=544\nallocs=3\nparams={\"evals\":334,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Connectivity/Graphs adapter disconnected",
            "value": 170.1825,
            "unit": "ns",
            "extra": "gctime=0\nmemory=496\nallocs=3\nparams={\"evals\":800,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Connectivity/native connected",
            "value": 95.12289915966386,
            "unit": "ns",
            "extra": "gctime=0\nmemory=0\nallocs=0\nparams={\"evals\":952,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Connectivity/native disconnected",
            "value": 27.31024096385542,
            "unit": "ns",
            "extra": "gctime=0\nmemory=0\nallocs=0\nparams={\"evals\":996,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 2 loops",
            "value": 6331.6,
            "unit": "ns",
            "extra": "gctime=0\nmemory=12416\nallocs=204\nparams={\"evals\":5,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 3 loops",
            "value": 47963,
            "unit": "ns",
            "extra": "gctime=0\nmemory=74816\nallocs=971\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 4 loops",
            "value": 2098554,
            "unit": "ns",
            "extra": "gctime=0\nmemory=964896\nallocs=7576\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 5 loops",
            "value": 107305516.5,
            "unit": "ns",
            "extra": "gctime=13920166.5\nmemory=213332912\nallocs=2494086\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 2 loops",
            "value": 1194.8,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2336\nallocs=21\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 3 loops",
            "value": 8917,
            "unit": "ns",
            "extra": "gctime=0\nmemory=17648\nallocs=106\nparams={\"evals\":3,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 4 loops",
            "value": 135460,
            "unit": "ns",
            "extra": "gctime=0\nmemory=277264\nallocs=1337\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 5 loops",
            "value": 4238431,
            "unit": "ns",
            "extra": "gctime=0\nmemory=6349696\nallocs=26462\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 6658,
            "unit": "ns",
            "extra": "gctime=0\nmemory=12936\nallocs=228\nparams={\"evals\":5,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 49274,
            "unit": "ns",
            "extra": "gctime=0\nmemory=75336\nallocs=995\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cached",
            "value": 170,
            "unit": "ns",
            "extra": "gctime=0\nmemory=192\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cold",
            "value": 90376,
            "unit": "ns",
            "extra": "gctime=0\nmemory=336528\nallocs=3021\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/allgraphs production",
            "value": 6780,
            "unit": "ns",
            "extra": "gctime=0\nmemory=12936\nallocs=228\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/canonical form",
            "value": 170.63040865384613,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":832,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/connected filter",
            "value": 88444,
            "unit": "ns",
            "extra": "gctime=0\nmemory=243552\nallocs=1542\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/isomorphism reduction",
            "value": 176336.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=393856\nallocs=3077\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 3 loops",
            "value": 159711,
            "unit": "ns",
            "extra": "gctime=0\nmemory=387168\nallocs=5013\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 4 loops",
            "value": 1233466,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2916048\nallocs=36370\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 5 loops",
            "value": 10478598,
            "unit": "ns",
            "extra": "gctime=0\nmemory=24117136\nallocs=292219\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/bipartite n8 native",
            "value": 329073,
            "unit": "ns",
            "extra": "gctime=0\nmemory=353600\nallocs=1335\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/bipartite n8 packed",
            "value": 333484,
            "unit": "ns",
            "extra": "gctime=0\nmemory=379936\nallocs=1408\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/bipartite n8 production",
            "value": 327856,
            "unit": "ns",
            "extra": "gctime=0\nmemory=353600\nallocs=1335\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/bipartite n8 row-reduced",
            "value": 343069,
            "unit": "ns",
            "extra": "gctime=0\nmemory=388736\nallocs=1475\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/fixed species n6 native",
            "value": 20300,
            "unit": "ns",
            "extra": "gctime=0\nmemory=24080\nallocs=364\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/fixed species n6 packed",
            "value": 23505,
            "unit": "ns",
            "extra": "gctime=0\nmemory=39744\nallocs=435\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/fixed species n6 production",
            "value": 19179,
            "unit": "ns",
            "extra": "gctime=0\nmemory=24080\nallocs=364\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/fixed species n6 row-reduced",
            "value": 25919,
            "unit": "ns",
            "extra": "gctime=0\nmemory=45040\nallocs=493\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/identity group n6 native",
            "value": 167098,
            "unit": "ns",
            "extra": "gctime=0\nmemory=180480\nallocs=3434\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/identity group n6 production",
            "value": 113822,
            "unit": "ns",
            "extra": "gctime=0\nmemory=171936\nallocs=3591\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/loop subset n6 native",
            "value": 60181,
            "unit": "ns",
            "extra": "gctime=0\nmemory=36480\nallocs=344\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/loop subset n6 packed",
            "value": 70587,
            "unit": "ns",
            "extra": "gctime=0\nmemory=74544\nallocs=515\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/loop subset n6 production",
            "value": 60106,
            "unit": "ns",
            "extra": "gctime=0\nmemory=36480\nallocs=344\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/loop subset n6 row-reduced",
            "value": 75113,
            "unit": "ns",
            "extra": "gctime=0\nmemory=90896\nallocs=666\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/canonicalize cycle n6 edge-list",
            "value": 19710,
            "unit": "ns",
            "extra": "gctime=0\nmemory=320\nallocs=2\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/canonicalize cycle n6 matrix",
            "value": 9057,
            "unit": "ns",
            "extra": "gctime=0\nmemory=752\nallocs=4\nparams={\"evals\":3,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/canonicalize cycle n6 triangular",
            "value": 4943.142857142857,
            "unit": "ns",
            "extra": "gctime=0\nmemory=384\nallocs=2\nparams={\"evals\":7,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/construct admissibility-refined n6",
            "value": 36345,
            "unit": "ns",
            "extra": "gctime=0\nmemory=105904\nallocs=1495\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/construct degree-split n6",
            "value": 2725.222222222222,
            "unit": "ns",
            "extra": "gctime=0\nmemory=7504\nallocs=99\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/construct loopless n6",
            "value": 2294.5555555555557,
            "unit": "ns",
            "extra": "gctime=0\nmemory=5488\nallocs=71\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/construct mixed-color n6",
            "value": 3163.6666666666665,
            "unit": "ns",
            "extra": "gctime=0\nmemory=9008\nallocs=117\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/generate loopless n5",
            "value": 31387,
            "unit": "ns",
            "extra": "gctime=0\nmemory=49408\nallocs=354\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
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
          "id": "01a04768bd94942a70efbd4ae8338bd71ab41b6d",
          "message": "refactor: extract exact coordinate-action primitives (#152)\n\nExtract shared exact coordinate-action application/comparison primitives and migrate the typed triangular canonicalizer without changing public semantics. Certified on exact PR head 475984632fcb5f7509b3eb6c63d25c90029b58fa.",
          "timestamp": "2026-09-15T07:15:15+02:00",
          "tree_id": "44736b23a3bc9c53bb7fbadd55af122a1a60d378",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/01a04768bd94942a70efbd4ae8338bd71ab41b6d"
        },
        "date": 1789449883374,
        "tool": "julia",
        "benches": [
          {
            "name": "Canonical/in-place - 2 internal",
            "value": 139.87373737373736,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":891,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 3 internal",
            "value": 272.58377659574467,
            "unit": "ns",
            "extra": "gctime=0\nmemory=608\nallocs=4\nparams={\"evals\":376,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 4 internal",
            "value": 962.0581395348837,
            "unit": "ns",
            "extra": "gctime=0\nmemory=720\nallocs=4\nparams={\"evals\":43,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 5 internal",
            "value": 5616.25,
            "unit": "ns",
            "extra": "gctime=0\nmemory=816\nallocs=4\nparams={\"evals\":6,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place mixed - 4 internal",
            "value": 784.0083333333333,
            "unit": "ns",
            "extra": "gctime=0\nmemory=624\nallocs=4\nparams={\"evals\":120,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 3 internal",
            "value": 222.0026785714286,
            "unit": "ns",
            "extra": "gctime=0\nmemory=672\nallocs=5\nparams={\"evals\":560,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 4 internal",
            "value": 489.7525252525253,
            "unit": "ns",
            "extra": "gctime=0\nmemory=864\nallocs=5\nparams={\"evals\":198,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 5 internal",
            "value": 1997.7,
            "unit": "ns",
            "extra": "gctime=0\nmemory=976\nallocs=5\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key - 5 internal",
            "value": 3863.125,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11920\nallocs=142\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key mixed - 4 internal",
            "value": 2882.9444444444443,
            "unit": "ns",
            "extra": "gctime=0\nmemory=8960\nallocs=110\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key symmetric - 5 internal",
            "value": 2714.3888888888887,
            "unit": "ns",
            "extra": "gctime=0\nmemory=7680\nallocs=77\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 2 internal",
            "value": 1247.8,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3744\nallocs=38\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 3 internal",
            "value": 2848.1111111111113,
            "unit": "ns",
            "extra": "gctime=0\nmemory=9008\nallocs=83\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 4 internal",
            "value": 10993,
            "unit": "ns",
            "extra": "gctime=0\nmemory=34352\nallocs=282\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 5 internal",
            "value": 62026,
            "unit": "ns",
            "extra": "gctime=0\nmemory=201296\nallocs=1458\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 2 internal",
            "value": 712.39375,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2224\nallocs=27\nparams={\"evals\":160,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 3 internal",
            "value": 1420.9,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3808\nallocs=48\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 4 internal",
            "value": 4265.8125,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11520\nallocs=139\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 5 internal",
            "value": 27634,
            "unit": "ns",
            "extra": "gctime=0\nmemory=78656\nallocs=739\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 4",
            "value": 2508035,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1570056\nallocs=10675\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 4 public",
            "value": 2488149,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1571608\nallocs=10677\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 5",
            "value": 67624114,
            "unit": "ns",
            "extra": "gctime=0\nmemory=12417944\nallocs=61834\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Connectivity/Graphs adapter connected",
            "value": 262.44456762749445,
            "unit": "ns",
            "extra": "gctime=0\nmemory=544\nallocs=3\nparams={\"evals\":451,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Connectivity/Graphs adapter disconnected",
            "value": 158.91666666666669,
            "unit": "ns",
            "extra": "gctime=0\nmemory=496\nallocs=3\nparams={\"evals\":846,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Connectivity/native connected",
            "value": 86.49843912591051,
            "unit": "ns",
            "extra": "gctime=0\nmemory=0\nallocs=0\nparams={\"evals\":961,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Connectivity/native disconnected",
            "value": 25.684738955823292,
            "unit": "ns",
            "extra": "gctime=0\nmemory=0\nallocs=0\nparams={\"evals\":996,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 2 loops",
            "value": 6457.4,
            "unit": "ns",
            "extra": "gctime=0\nmemory=12416\nallocs=204\nparams={\"evals\":5,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 3 loops",
            "value": 46872.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=74816\nallocs=971\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 4 loops",
            "value": 2313082,
            "unit": "ns",
            "extra": "gctime=0\nmemory=964896\nallocs=7576\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 5 loops",
            "value": 102154606,
            "unit": "ns",
            "extra": "gctime=11846825\nmemory=213332912\nallocs=2494086\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 2 loops",
            "value": 1223.85,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2336\nallocs=21\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 3 loops",
            "value": 8279.125,
            "unit": "ns",
            "extra": "gctime=0\nmemory=17648\nallocs=106\nparams={\"evals\":4,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 4 loops",
            "value": 132150,
            "unit": "ns",
            "extra": "gctime=0\nmemory=277264\nallocs=1337\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 5 loops",
            "value": 3944344,
            "unit": "ns",
            "extra": "gctime=0\nmemory=6349696\nallocs=26462\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 7027.4,
            "unit": "ns",
            "extra": "gctime=0\nmemory=12936\nallocs=228\nparams={\"evals\":5,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 50480,
            "unit": "ns",
            "extra": "gctime=0\nmemory=75336\nallocs=995\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cached",
            "value": 150,
            "unit": "ns",
            "extra": "gctime=0\nmemory=192\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cold",
            "value": 81276,
            "unit": "ns",
            "extra": "gctime=0\nmemory=336528\nallocs=3021\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/allgraphs production",
            "value": 7110,
            "unit": "ns",
            "extra": "gctime=0\nmemory=12936\nallocs=228\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/canonical form",
            "value": 144.47184684684686,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":888,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/connected filter",
            "value": 85335.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=243552\nallocs=1542\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/isomorphism reduction",
            "value": 150259,
            "unit": "ns",
            "extra": "gctime=0\nmemory=393856\nallocs=3077\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 3 loops",
            "value": 156393,
            "unit": "ns",
            "extra": "gctime=0\nmemory=387168\nallocs=5013\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 4 loops",
            "value": 1234650,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2916048\nallocs=36370\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 5 loops",
            "value": 10364476,
            "unit": "ns",
            "extra": "gctime=0\nmemory=24117136\nallocs=292219\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/bipartite n8 native",
            "value": 332122.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=353600\nallocs=1335\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/bipartite n8 packed",
            "value": 347400.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=379936\nallocs=1408\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/bipartite n8 production",
            "value": 332728,
            "unit": "ns",
            "extra": "gctime=0\nmemory=353600\nallocs=1335\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/bipartite n8 row-reduced",
            "value": 345430,
            "unit": "ns",
            "extra": "gctime=0\nmemory=388736\nallocs=1475\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/fixed species n6 native",
            "value": 20834.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=24080\nallocs=364\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/fixed species n6 packed",
            "value": 22733.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=39744\nallocs=435\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/fixed species n6 production",
            "value": 19007.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=24080\nallocs=364\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/fixed species n6 row-reduced",
            "value": 23547,
            "unit": "ns",
            "extra": "gctime=0\nmemory=45040\nallocs=493\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/identity group n6 native",
            "value": 179187,
            "unit": "ns",
            "extra": "gctime=0\nmemory=180480\nallocs=3434\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/identity group n6 production",
            "value": 119386.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=171936\nallocs=3591\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/loop subset n6 native",
            "value": 62420,
            "unit": "ns",
            "extra": "gctime=0\nmemory=36480\nallocs=344\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/loop subset n6 packed",
            "value": 73211,
            "unit": "ns",
            "extra": "gctime=0\nmemory=74544\nallocs=515\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/loop subset n6 production",
            "value": 61117,
            "unit": "ns",
            "extra": "gctime=0\nmemory=36480\nallocs=344\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/loop subset n6 row-reduced",
            "value": 73822,
            "unit": "ns",
            "extra": "gctime=0\nmemory=90896\nallocs=666\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/canonicalize cycle n6 edge-list",
            "value": 16246,
            "unit": "ns",
            "extra": "gctime=0\nmemory=320\nallocs=2\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/canonicalize cycle n6 matrix",
            "value": 8647,
            "unit": "ns",
            "extra": "gctime=0\nmemory=752\nallocs=4\nparams={\"evals\":3,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/canonicalize cycle n6 triangular",
            "value": 5439.25,
            "unit": "ns",
            "extra": "gctime=0\nmemory=384\nallocs=2\nparams={\"evals\":6,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/construct admissibility-refined n6",
            "value": 37435,
            "unit": "ns",
            "extra": "gctime=0\nmemory=105904\nallocs=1495\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/construct degree-split n6",
            "value": 3233.777777777778,
            "unit": "ns",
            "extra": "gctime=0\nmemory=7504\nallocs=99\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/construct loopless n6",
            "value": 2305.777777777778,
            "unit": "ns",
            "extra": "gctime=0\nmemory=5488\nallocs=71\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/construct mixed-color n6",
            "value": 3162.833333333333,
            "unit": "ns",
            "extra": "gctime=0\nmemory=9008\nallocs=117\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/generate loopless n5",
            "value": 29833,
            "unit": "ns",
            "extra": "gctime=0\nmemory=49408\nallocs=354\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
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
          "id": "c692cf92a4f4d796e35e31e8e1996f2c4acd13cd",
          "message": "refactor: precompile colored-port canonical actions (#153)\n\nPrecompile exact colored-port coordinate actions while preserving canonical keys, witnesses, pruning, and transport semantics. Re-certified after restacking onto merged #152; exact tested tree 5654f6dbb5fc0009153aec085818a9254653da5c.",
          "timestamp": "2026-09-15T07:26:49+02:00",
          "tree_id": "5654f6dbb5fc0009153aec085818a9254653da5c",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/c692cf92a4f4d796e35e31e8e1996f2c4acd13cd"
        },
        "date": 1789450597623,
        "tool": "julia",
        "benches": [
          {
            "name": "Canonical/in-place - 2 internal",
            "value": 156.62351543942992,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":842,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 3 internal",
            "value": 297.6258865248227,
            "unit": "ns",
            "extra": "gctime=0\nmemory=608\nallocs=4\nparams={\"evals\":282,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 4 internal",
            "value": 1076.2,
            "unit": "ns",
            "extra": "gctime=0\nmemory=720\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 5 internal",
            "value": 6560,
            "unit": "ns",
            "extra": "gctime=0\nmemory=816\nallocs=4\nparams={\"evals\":5,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place mixed - 4 internal",
            "value": 878.484126984127,
            "unit": "ns",
            "extra": "gctime=0\nmemory=624\nallocs=4\nparams={\"evals\":63,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 3 internal",
            "value": 254.56733167082294,
            "unit": "ns",
            "extra": "gctime=0\nmemory=672\nallocs=5\nparams={\"evals\":401,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 4 internal",
            "value": 579.1157894736842,
            "unit": "ns",
            "extra": "gctime=0\nmemory=864\nallocs=5\nparams={\"evals\":190,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 5 internal",
            "value": 2339.4444444444443,
            "unit": "ns",
            "extra": "gctime=0\nmemory=976\nallocs=5\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key - 5 internal",
            "value": 4586.857142857143,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11920\nallocs=142\nparams={\"evals\":7,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key mixed - 4 internal",
            "value": 3371.8125,
            "unit": "ns",
            "extra": "gctime=0\nmemory=8960\nallocs=110\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key symmetric - 5 internal",
            "value": 3177.5555555555557,
            "unit": "ns",
            "extra": "gctime=0\nmemory=7680\nallocs=77\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 2 internal",
            "value": 1385.7,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3744\nallocs=38\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 3 internal",
            "value": 3259.8125,
            "unit": "ns",
            "extra": "gctime=0\nmemory=9008\nallocs=83\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 4 internal",
            "value": 12375,
            "unit": "ns",
            "extra": "gctime=0\nmemory=34352\nallocs=282\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 5 internal",
            "value": 71070.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=201296\nallocs=1458\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 2 internal",
            "value": 822.7027027027027,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2224\nallocs=27\nparams={\"evals\":111,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 3 internal",
            "value": 1589,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3808\nallocs=48\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 4 internal",
            "value": 4962.571428571428,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11520\nallocs=139\nparams={\"evals\":7,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 5 internal",
            "value": 30583,
            "unit": "ns",
            "extra": "gctime=0\nmemory=78656\nallocs=739\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 4",
            "value": 2181706,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1576104\nallocs=10724\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 4 public",
            "value": 2181246,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1577656\nallocs=10726\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 5",
            "value": 56886574,
            "unit": "ns",
            "extra": "gctime=0\nmemory=12583288\nallocs=62080\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Connectivity/Graphs adapter connected",
            "value": 283.23899371069183,
            "unit": "ns",
            "extra": "gctime=0\nmemory=544\nallocs=3\nparams={\"evals\":318,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Connectivity/Graphs adapter disconnected",
            "value": 179.6843112244898,
            "unit": "ns",
            "extra": "gctime=0\nmemory=496\nallocs=3\nparams={\"evals\":784,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Connectivity/native connected",
            "value": 100.41039236479321,
            "unit": "ns",
            "extra": "gctime=0\nmemory=0\nallocs=0\nparams={\"evals\":943,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Connectivity/native disconnected",
            "value": 29.797989949748743,
            "unit": "ns",
            "extra": "gctime=0\nmemory=0\nallocs=0\nparams={\"evals\":995,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 2 loops",
            "value": 7279,
            "unit": "ns",
            "extra": "gctime=0\nmemory=12416\nallocs=204\nparams={\"evals\":4,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 3 loops",
            "value": 54081,
            "unit": "ns",
            "extra": "gctime=0\nmemory=74816\nallocs=971\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 4 loops",
            "value": 2562413,
            "unit": "ns",
            "extra": "gctime=0\nmemory=964896\nallocs=7576\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 5 loops",
            "value": 121241737.5,
            "unit": "ns",
            "extra": "gctime=15072127.5\nmemory=213332912\nallocs=2494086\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 2 loops",
            "value": 1356.35,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2336\nallocs=21\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 3 loops",
            "value": 9621,
            "unit": "ns",
            "extra": "gctime=0\nmemory=17648\nallocs=106\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 4 loops",
            "value": 153322.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=277264\nallocs=1337\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 5 loops",
            "value": 4480423,
            "unit": "ns",
            "extra": "gctime=0\nmemory=6349696\nallocs=26462\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 7705,
            "unit": "ns",
            "extra": "gctime=0\nmemory=12936\nallocs=228\nparams={\"evals\":4,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 55107,
            "unit": "ns",
            "extra": "gctime=0\nmemory=75336\nallocs=995\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cached",
            "value": 197,
            "unit": "ns",
            "extra": "gctime=0\nmemory=192\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cold",
            "value": 95001.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=336528\nallocs=3021\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/allgraphs production",
            "value": 7797,
            "unit": "ns",
            "extra": "gctime=0\nmemory=12936\nallocs=228\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/canonical form",
            "value": 153.6367370892019,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":852,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/connected filter",
            "value": 89905.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=243552\nallocs=1542\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/isomorphism reduction",
            "value": 168011.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=393856\nallocs=3077\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 3 loops",
            "value": 180434.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=387168\nallocs=5013\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 4 loops",
            "value": 1433993,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2916048\nallocs=36370\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 5 loops",
            "value": 11823358,
            "unit": "ns",
            "extra": "gctime=0\nmemory=24117136\nallocs=292219\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/bipartite n8 native",
            "value": 371586,
            "unit": "ns",
            "extra": "gctime=0\nmemory=353600\nallocs=1335\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/bipartite n8 packed",
            "value": 383658.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=379936\nallocs=1408\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/bipartite n8 production",
            "value": 385609,
            "unit": "ns",
            "extra": "gctime=0\nmemory=353600\nallocs=1335\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/bipartite n8 row-reduced",
            "value": 386562,
            "unit": "ns",
            "extra": "gctime=0\nmemory=388736\nallocs=1475\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/fixed species n6 native",
            "value": 22723,
            "unit": "ns",
            "extra": "gctime=0\nmemory=24080\nallocs=364\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/fixed species n6 packed",
            "value": 25577.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=39744\nallocs=435\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/fixed species n6 production",
            "value": 22895,
            "unit": "ns",
            "extra": "gctime=0\nmemory=24080\nallocs=364\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/fixed species n6 row-reduced",
            "value": 28602,
            "unit": "ns",
            "extra": "gctime=0\nmemory=45040\nallocs=493\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/identity group n6 native",
            "value": 199416.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=180480\nallocs=3434\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/identity group n6 production",
            "value": 132815,
            "unit": "ns",
            "extra": "gctime=0\nmemory=171936\nallocs=3591\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/loop subset n6 native",
            "value": 69354,
            "unit": "ns",
            "extra": "gctime=0\nmemory=36480\nallocs=344\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/loop subset n6 packed",
            "value": 81377,
            "unit": "ns",
            "extra": "gctime=0\nmemory=74544\nallocs=515\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/loop subset n6 production",
            "value": 68872,
            "unit": "ns",
            "extra": "gctime=0\nmemory=36480\nallocs=344\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/loop subset n6 row-reduced",
            "value": 82284,
            "unit": "ns",
            "extra": "gctime=0\nmemory=90896\nallocs=666\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/canonicalize cycle n6 edge-list",
            "value": 18450,
            "unit": "ns",
            "extra": "gctime=0\nmemory=320\nallocs=2\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/canonicalize cycle n6 matrix",
            "value": 10029.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=752\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/canonicalize cycle n6 triangular",
            "value": 6085.8,
            "unit": "ns",
            "extra": "gctime=0\nmemory=384\nallocs=2\nparams={\"evals\":5,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/construct admissibility-refined n6",
            "value": 41606,
            "unit": "ns",
            "extra": "gctime=0\nmemory=105904\nallocs=1495\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/construct degree-split n6",
            "value": 3099,
            "unit": "ns",
            "extra": "gctime=0\nmemory=7504\nallocs=99\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/construct loopless n6",
            "value": 2517.6666666666665,
            "unit": "ns",
            "extra": "gctime=0\nmemory=5488\nallocs=71\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/construct mixed-color n6",
            "value": 3478.625,
            "unit": "ns",
            "extra": "gctime=0\nmemory=9008\nallocs=117\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/generate loopless n5",
            "value": 33055.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=49408\nallocs=354\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
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
          "id": "2ae1d16190f3953859874023305141b63013f4a8",
          "message": "perf: production directed canonicalization workspace (#159)\n\nCertified production integration for exact colored directed canonical labeling with reusable zero-allocation workspace kernels, permanent benchmark coverage, and downstream KC acceptance.",
          "timestamp": "2026-09-16T20:20:43+02:00",
          "tree_id": "6ca9d25d03dd83908cbaa1f49e32c4556c99b445",
          "url": "https://github.com/oameye/GraphCombinations.jl/commit/2ae1d16190f3953859874023305141b63013f4a8"
        },
        "date": 1789583643034,
        "tool": "julia",
        "benches": [
          {
            "name": "Canonical/in-place - 2 internal",
            "value": 219.82488479262673,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":651,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 3 internal",
            "value": 400.8373786407767,
            "unit": "ns",
            "extra": "gctime=0\nmemory=608\nallocs=4\nparams={\"evals\":206,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 4 internal",
            "value": 1793.7,
            "unit": "ns",
            "extra": "gctime=0\nmemory=720\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place - 5 internal",
            "value": 8996.666666666666,
            "unit": "ns",
            "extra": "gctime=0\nmemory=816\nallocs=4\nparams={\"evals\":3,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/in-place mixed - 4 internal",
            "value": 1313.9,
            "unit": "ns",
            "extra": "gctime=0\nmemory=624\nallocs=4\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 3 internal",
            "value": 326.9721189591078,
            "unit": "ns",
            "extra": "gctime=0\nmemory=672\nallocs=5\nparams={\"evals\":269,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 4 internal",
            "value": 695.2363636363636,
            "unit": "ns",
            "extra": "gctime=0\nmemory=864\nallocs=5\nparams={\"evals\":165,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/matrix - 5 internal",
            "value": 2754.1111111111113,
            "unit": "ns",
            "extra": "gctime=0\nmemory=976\nallocs=5\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key - 5 internal",
            "value": 5478.166666666667,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11920\nallocs=142\nparams={\"evals\":6,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key mixed - 4 internal",
            "value": 4067.4285714285716,
            "unit": "ns",
            "extra": "gctime=0\nmemory=8960\nallocs=110\nparams={\"evals\":7,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/partition key symmetric - 5 internal",
            "value": 3711.0625,
            "unit": "ns",
            "extra": "gctime=0\nmemory=7680\nallocs=77\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 2 internal",
            "value": 1612.4,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3744\nallocs=38\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 3 internal",
            "value": 3925.75,
            "unit": "ns",
            "extra": "gctime=0\nmemory=9008\nallocs=83\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 4 internal",
            "value": 15373,
            "unit": "ns",
            "extra": "gctime=0\nmemory=34352\nallocs=282\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/reference - 5 internal",
            "value": 86998,
            "unit": "ns",
            "extra": "gctime=0\nmemory=201296\nallocs=1458\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 2 internal",
            "value": 1025.797619047619,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2224\nallocs=27\nparams={\"evals\":42,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 3 internal",
            "value": 1918.8,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3808\nallocs=48\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 4 internal",
            "value": 6407.6,
            "unit": "ns",
            "extra": "gctime=0\nmemory=11520\nallocs=139\nparams={\"evals\":5,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Canonical/scratch - 5 internal",
            "value": 39589,
            "unit": "ns",
            "extra": "gctime=0\nmemory=78656\nallocs=739\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 4",
            "value": 2400270,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1576104\nallocs=10724\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 4 public",
            "value": 2430214,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1577656\nallocs=10726\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Colored port generation/order 5",
            "value": 64389489,
            "unit": "ns",
            "extra": "gctime=0\nmemory=12583288\nallocs=62080\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Connectivity/Graphs adapter connected",
            "value": 361.08181818181816,
            "unit": "ns",
            "extra": "gctime=0\nmemory=544\nallocs=3\nparams={\"evals\":220,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Connectivity/Graphs adapter disconnected",
            "value": 222.90877192982455,
            "unit": "ns",
            "extra": "gctime=0\nmemory=496\nallocs=3\nparams={\"evals\":570,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Connectivity/native connected",
            "value": 134.49484536082474,
            "unit": "ns",
            "extra": "gctime=0\nmemory=0\nallocs=0\nparams={\"evals\":873,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Connectivity/native disconnected",
            "value": 40.442986881937436,
            "unit": "ns",
            "extra": "gctime=0\nmemory=0\nallocs=0\nparams={\"evals\":991,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 2 loops",
            "value": 8096.75,
            "unit": "ns",
            "extra": "gctime=0\nmemory=12416\nallocs=204\nparams={\"evals\":4,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 3 loops",
            "value": 61851,
            "unit": "ns",
            "extra": "gctime=0\nmemory=74816\nallocs=971\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 4 loops",
            "value": 2576451,
            "unit": "ns",
            "extra": "gctime=0\nmemory=964896\nallocs=7576\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/allgraphs - 5 loops",
            "value": 128643822,
            "unit": "ns",
            "extra": "gctime=14627405\nmemory=213332912\nallocs=2494086\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 2 loops",
            "value": 1479.2,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2336\nallocs=21\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 3 loops",
            "value": 11687.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=17648\nallocs=106\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 4 loops",
            "value": 168634.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=277264\nallocs=1337\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Direct/labeled candidates - 5 loops",
            "value": 5275724,
            "unit": "ns",
            "extra": "gctime=0\nmemory=6349696\nallocs=26462\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/almost discrete colors/certified allocating",
            "value": 2469.722222222222,
            "unit": "ns",
            "extra": "gctime=0\nmemory=7280\nallocs=56\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/almost discrete colors/workspace setup + run",
            "value": 1097.6,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3600\nallocs=13\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/almost discrete colors/workspace warmed",
            "value": 454.66161616161617,
            "unit": "ns",
            "extra": "gctime=0\nmemory=0\nallocs=0\nparams={\"evals\":198,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/bidirectional cycle/certified allocating",
            "value": 46548,
            "unit": "ns",
            "extra": "gctime=0\nmemory=106208\nallocs=982\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/bidirectional cycle/workspace setup + run",
            "value": 10891.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2944\nallocs=13\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/bidirectional cycle/workspace warmed",
            "value": 10415,
            "unit": "ns",
            "extra": "gctime=0\nmemory=0\nallocs=0\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/directed cycle/certified allocating",
            "value": 24016,
            "unit": "ns",
            "extra": "gctime=0\nmemory=54016\nallocs=478\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/directed cycle/workspace setup + run",
            "value": 7080.6,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2944\nallocs=13\nparams={\"evals\":5,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/directed cycle/workspace warmed",
            "value": 5803.666666666667,
            "unit": "ns",
            "extra": "gctime=0\nmemory=0\nallocs=0\nparams={\"evals\":6,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/disconnected colored/certified allocating",
            "value": 16494,
            "unit": "ns",
            "extra": "gctime=0\nmemory=37152\nallocs=390\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/disconnected colored/workspace setup + run",
            "value": 3550.25,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1984\nallocs=13\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/disconnected colored/workspace warmed",
            "value": 2665,
            "unit": "ns",
            "extra": "gctime=0\nmemory=0\nallocs=0\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/fixed center/certified allocating",
            "value": 1901993,
            "unit": "ns",
            "extra": "gctime=0\nmemory=4221856\nallocs=40628\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/fixed center/workspace setup + run",
            "value": 348084.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2944\nallocs=13\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/fixed center/workspace warmed",
            "value": 329237,
            "unit": "ns",
            "extra": "gctime=0\nmemory=0\nallocs=0\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/high symmetry/certified allocating",
            "value": 1657817,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3685360\nallocs=36917\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/high symmetry/workspace setup + run",
            "value": 265112.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2560\nallocs=13\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/high symmetry/workspace warmed",
            "value": 263735,
            "unit": "ns",
            "extra": "gctime=0\nmemory=0\nallocs=0\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/loops and multiplicity/certified allocating",
            "value": 1472.1,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3760\nallocs=40\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/loops and multiplicity/workspace setup + run",
            "value": 611.3113207547169,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1712\nallocs=13\nparams={\"evals\":159,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/loops and multiplicity/workspace warmed",
            "value": 269.1463414634146,
            "unit": "ns",
            "extra": "gctime=0\nmemory=0\nallocs=0\nparams={\"evals\":328,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/many small unresolved cells/certified allocating",
            "value": 322336.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=909904\nallocs=6519\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/many small unresolved cells/workspace setup + run",
            "value": 57806,
            "unit": "ns",
            "extra": "gctime=0\nmemory=6608\nallocs=13\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/many small unresolved cells/workspace warmed",
            "value": 57585,
            "unit": "ns",
            "extra": "gctime=0\nmemory=0\nallocs=0\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/scaling/bidirectional cycle n=3",
            "value": 1102.6,
            "unit": "ns",
            "extra": "gctime=0\nmemory=0\nallocs=0\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/scaling/bidirectional cycle n=5",
            "value": 4565.428571428572,
            "unit": "ns",
            "extra": "gctime=0\nmemory=0\nallocs=0\nparams={\"evals\":7,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/scaling/bidirectional cycle n=7",
            "value": 10465,
            "unit": "ns",
            "extra": "gctime=0\nmemory=0\nallocs=0\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/scaling/bidirectional cycle n=9",
            "value": 26059,
            "unit": "ns",
            "extra": "gctime=0\nmemory=0\nallocs=0\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/scaling/directed cycle n=3",
            "value": 664.129213483146,
            "unit": "ns",
            "extra": "gctime=0\nmemory=0\nallocs=0\nparams={\"evals\":178,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/scaling/directed cycle n=5",
            "value": 2297.8888888888887,
            "unit": "ns",
            "extra": "gctime=0\nmemory=0\nallocs=0\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/scaling/directed cycle n=7",
            "value": 6040.666666666667,
            "unit": "ns",
            "extra": "gctime=0\nmemory=0\nallocs=0\nparams={\"evals\":6,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/scaling/directed cycle n=9",
            "value": 13400,
            "unit": "ns",
            "extra": "gctime=0\nmemory=0\nallocs=0\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/subdivision style/certified allocating",
            "value": 7601.25,
            "unit": "ns",
            "extra": "gctime=0\nmemory=21664\nallocs=163\nparams={\"evals\":4,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/subdivision style/workspace setup + run",
            "value": 2482.5555555555557,
            "unit": "ns",
            "extra": "gctime=0\nmemory=5024\nallocs=13\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/subdivision style/workspace warmed",
            "value": 1762.6,
            "unit": "ns",
            "extra": "gctime=0\nmemory=0\nallocs=0\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/tiny colored/certified allocating",
            "value": 1501.2,
            "unit": "ns",
            "extra": "gctime=0\nmemory=3824\nallocs=40\nparams={\"evals\":10,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/tiny colored/workspace setup + run",
            "value": 604.1129943502825,
            "unit": "ns",
            "extra": "gctime=0\nmemory=1712\nallocs=13\nparams={\"evals\":177,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Directed canonicalization/tiny colored/workspace warmed",
            "value": 254.39013452914799,
            "unit": "ns",
            "extra": "gctime=0\nmemory=0\nallocs=0\nparams={\"evals\":446,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/2 loops",
            "value": 9197,
            "unit": "ns",
            "extra": "gctime=0\nmemory=12936\nallocs=228\nparams={\"evals\":3,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Phi^4 theory/3 loops",
            "value": 64475.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=75336\nallocs=995\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cached",
            "value": 220,
            "unit": "ns",
            "extra": "gctime=0\nmemory=192\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/Wick pairings cold",
            "value": 114079,
            "unit": "ns",
            "extra": "gctime=0\nmemory=336528\nallocs=3021\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/allgraphs production",
            "value": 8717.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=12936\nallocs=228\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/canonical form",
            "value": 212.97503900156005,
            "unit": "ns",
            "extra": "gctime=0\nmemory=512\nallocs=4\nparams={\"evals\":641,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/connected filter",
            "value": 117514,
            "unit": "ns",
            "extra": "gctime=0\nmemory=243552\nallocs=1542\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Pipeline/isomorphism reduction",
            "value": 227852,
            "unit": "ns",
            "extra": "gctime=0\nmemory=393856\nallocs=3077\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 3 loops",
            "value": 197993,
            "unit": "ns",
            "extra": "gctime=0\nmemory=387168\nallocs=5013\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 4 loops",
            "value": 1538215,
            "unit": "ns",
            "extra": "gctime=0\nmemory=2916048\nallocs=36370\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "RowReduced/allgraphs - 5 loops",
            "value": 13056438.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=24117136\nallocs=292219\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":10,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/bipartite n8 native",
            "value": 417838,
            "unit": "ns",
            "extra": "gctime=0\nmemory=353600\nallocs=1335\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/bipartite n8 packed",
            "value": 439920,
            "unit": "ns",
            "extra": "gctime=0\nmemory=379936\nallocs=1408\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/bipartite n8 production",
            "value": 418143,
            "unit": "ns",
            "extra": "gctime=0\nmemory=353600\nallocs=1335\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/bipartite n8 row-reduced",
            "value": 443751.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=388736\nallocs=1475\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/fixed species n6 native",
            "value": 24436,
            "unit": "ns",
            "extra": "gctime=0\nmemory=24080\nallocs=364\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/fixed species n6 packed",
            "value": 29964,
            "unit": "ns",
            "extra": "gctime=0\nmemory=39744\nallocs=435\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/fixed species n6 production",
            "value": 24436,
            "unit": "ns",
            "extra": "gctime=0\nmemory=24080\nallocs=364\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/fixed species n6 row-reduced",
            "value": 33249,
            "unit": "ns",
            "extra": "gctime=0\nmemory=45040\nallocs=493\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/identity group n6 native",
            "value": 212749.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=180480\nallocs=3434\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/identity group n6 production",
            "value": 147338,
            "unit": "ns",
            "extra": "gctime=0\nmemory=171936\nallocs=3591\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/loop subset n6 native",
            "value": 76363,
            "unit": "ns",
            "extra": "gctime=0\nmemory=36480\nallocs=344\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/loop subset n6 packed",
            "value": 92557,
            "unit": "ns",
            "extra": "gctime=0\nmemory=74544\nallocs=515\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/loop subset n6 production",
            "value": 76543.5,
            "unit": "ns",
            "extra": "gctime=0\nmemory=36480\nallocs=344\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed continuation reduction/loop subset n6 row-reduced",
            "value": 97214,
            "unit": "ns",
            "extra": "gctime=0\nmemory=90896\nallocs=666\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/canonicalize cycle n6 edge-list",
            "value": 25338,
            "unit": "ns",
            "extra": "gctime=0\nmemory=320\nallocs=2\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/canonicalize cycle n6 matrix",
            "value": 11688,
            "unit": "ns",
            "extra": "gctime=0\nmemory=752\nallocs=4\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/canonicalize cycle n6 triangular",
            "value": 6075,
            "unit": "ns",
            "extra": "gctime=0\nmemory=384\nallocs=2\nparams={\"evals\":5,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/construct admissibility-refined n6",
            "value": 45357,
            "unit": "ns",
            "extra": "gctime=0\nmemory=105904\nallocs=1495\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/construct degree-split n6",
            "value": 3499.5625,
            "unit": "ns",
            "extra": "gctime=0\nmemory=7504\nallocs=99\nparams={\"evals\":8,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/construct loopless n6",
            "value": 2956.5555555555557,
            "unit": "ns",
            "extra": "gctime=0\nmemory=5488\nallocs=71\nparams={\"evals\":9,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/construct mixed-color n6",
            "value": 4044.5714285714284,
            "unit": "ns",
            "extra": "gctime=0\nmemory=9008\nallocs=117\nparams={\"evals\":7,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          },
          {
            "name": "Typed multigraph generation/generate loopless n5",
            "value": 38957,
            "unit": "ns",
            "extra": "gctime=0\nmemory=49408\nallocs=354\nparams={\"evals\":1,\"evals_set\":false,\"gcsample\":false,\"gctrial\":true,\"memory_tolerance\":0.01,\"overhead\":0,\"samples\":10000,\"seconds\":5,\"time_tolerance\":0.05}"
          }
        ]
      }
    ]
  }
}