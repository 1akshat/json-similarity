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
      .then((response) => {
        console.log("OK");
        // handle success
        response = response.data;
        if (response.success === false) {
          console.log("THROW ERROR");
          throw new Error(response["errors"][0]);
        }
        let modalButton = document.getElementById("open-modal");
        modalButton.dataset.target = "#exampleModal";
        modalButton.click();
        document.getElementById("show-diff-button").style.display = "block";
        const table = document.getElementById("diffTable");
        document.getElementById(
          "success-message"
        ).innerHTML = `The similarity score between the given json files is: ${response.result.score}`;
        // Resetting the existing table rows
        while (table.rows.length > 1) {
          table.deleteRow(1);
        }
        for (const data of response.result.diff) {
          let row = table.insertRow();
          let key = row.insertCell(0);
          key.innerHTML = data.key;
          let value = row.insertCell(1);
          value.innerHTML = data.value;
        }
      })
      .catch((error) => {
        // handle error
        document.getElementById("error-alert").style.display = "block";
        document.getElementById("error-message").innerHTML = `Invalid JSON`;
        setTimeout(() => {
          document.getElementById("error-alert").style.display = "none";
        }, 2000);
      })
      .finally(() => {
        // always executed
      });
  } catch {
    // Don't Show the modal in case of invalid json
    let modalButton = document.getElementById("open-modal");
    modalButton.dataset.target = "";
    document.getElementById("error-alert").style.display = "block";
    document.getElementById("error-message").innerHTML = `Invalid JSON`;
    setTimeout(() => {
      document.getElementById("error-alert").style.display = "none";
    }, 2000);
  }
};
