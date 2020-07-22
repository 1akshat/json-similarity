const axios = require("axios").default;

const getJsonSimilarity = () => {
  axios
    .get("/compare_json_files")
    .then(function (response) {
      // handle success
      response = response.data;
      console.log(response);
    })
    .catch(function (error) {
      // handle error
      console.log(error);
    })
    .finally(function () {
      // always executed
    });
};
