# JSON Object Similarity Score

[![Website https://json-similarity.herokuapp.com/](https://img.shields.io/website-up-down-green-red/http/monip.org.svg)](https://json-similarity.herokuapp.com/) <img src="https://img.shields.io/badge/made%20with-rails-red.svg" alt="made with rails"> ![BuiltBy](https://img.shields.io/badge/Rails-Lovers-black.svg "img.shields.io") <img src="https://img.shields.io/badge/made%20with-javascript-blue.svg" alt="made with javascript"> ![BuiltBy](https://img.shields.io/badge/Javascript-Lovers-black.svg "img.shields.io") [![MIT license](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)

This Repo aims at calculating the similarity score of two valid json objects. The Score varies from `0 to 1`.`0` being non-similar and `1` being fully identical.

---

### How Scoring Algorithm Works?

- The overall program expects two json objects as an input.

* Each and Every key/value pairs of both the json inputs are compared to one another. The logic is to traverse through one of the Hash and finding the same key value in the other Hash.
  Cases:

  - If the key/value is present in both
    - Their is an equality check and on the basis of that equality global counters for truthy and falsy values are increamented.
  - If key/value is missing in one
    - In this case the key/value for the missing one is set as empty hash {} and then the same check is done as former.

* It traverse through the complete json and then finally Counters are captured for truthy and falsy values.

* Finally, Score is Calculated using:
  `Truthy / Truthy + Falsy`

> NOTE: The score value is returned from range `0` - `1` `.`0`being completely non-identical and`1` being completely identical.

---

### Steps to Run the project locally:

```js
* Clone the repo: https://github.com/1akshat/json-similarity.git
* Navigate to the respective directory:
    cd json-similarity/
* Install all the dependencies.
    Run: bundle install
* Start The Server.
    RUN: rails s
* Visit: http://localhost:3000
```

---

### Preview

![alt text](https://i.ibb.co/C0rKn4p/Screenshot.png)

### Website Link

https://json-similarity.herokuapp.com/
