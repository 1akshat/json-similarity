const axios = require("axios").default;

window.getJsonSimilarity = () => {
  const json1 = document.getElementById("json1").value;
  const json2 = document.getElementById("json2").value;
  try {
    axios({
      method: "post",
      url: "/compare_json_files",
      data: {
        file1_data: JSON.parse(json1),
        file2_data: JSON.parse(json2),
      },
      headers: {
        "Content-type": "application/json",
        charset: "utf-8",
      },
    })
      .then(function (response) {
        // handle success
        response = response.data;
        console.log(response);
        if (response.success === false) {
          throw new Error(response["errors"][0]);
        }
        document.getElementById("success-alert").style.display = "none";
        document.getElementById("success-alert").style.display = "block";
        document.getElementById(
          "success-message"
        ).innerHTML = `The Similarity score between the given json files is: ${response.result.score}`;
      })
      .catch(function (error) {
        // handle error
        console.log(error);
        document.getElementById("error-alert").style.display = "block";
        document.getElementById("error-message").innerHTML = `Invalid JSON`;
        setTimeout(function () {
          document.getElementById("error-alert").style.display = "none";
        }, 2000);
      })
      .finally(function () {
        // always executed
      });
  } catch {
    document.getElementById("error-alert").style.display = "block";
    document.getElementById("error-message").innerHTML = `Invalid JSON`;
    setTimeout(function () {
      document.getElementById("error-alert").style.display = "none";
    }, 2000);
  }
};
