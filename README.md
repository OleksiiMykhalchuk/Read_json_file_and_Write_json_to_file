# Read_json_file_and_Write_json_to_file
Read Json File and Write Json json to file in Swift

This is the class with two methods:
1. reads local json file and decode it.
2. encode object and write file to document derictory.

# Example 

## We have got a json file with structure:
```
{
"questions": [
  {
     "number": 1,
     "question": "Ann .... shopping every day.",
     "choices": ["is going","goes","go","has gone"],
     "correctAnswer":1
  },
  {
    "number":2,
     "question": "Frank and Henry .... tennis now.",
     "choices": ["are playing", "play", "were playing", "played"],
     "correctAnswer":0  }]
}
```
### They represent the questions for english quiz.
## For some reason we need to change the structure of json to this:
```
{
"questions":[
  {"choices":
    [{"correct":false,"text":"is going"},
    {"correct":true,"text":"goes"},
    {"correct":false,"text":"go"},
    {"correct":false,"text":"has gone"}],
  "question":"Ann .... shopping every day."},
  {"choices":[{"correct":true,"text":"are playing"},
    {"correct":false,"text":"play"},
    {"correct":false,"text":"were playing"},
    {"correct":false,"text":"played"}],
  "question":"Frank and Henry .... tennis now."}]
}
```
## We create the models
```
struct Question: Codable {
    let number: Int
    let question: String
    let choices: [String]
    let correctAnswer: Int
}
struct Questions: Codable {
    let questions: [Question]
}

struct Modified: Codable {
    let questions: [ModifiedContent]
}
struct ModifiedContent: Codable {
    let question: String
    let choices: [Choices]
}
struct Choices: Codable {
    var correct: Bool = false
    var text: String
}
```
## and the method which converts one object structure to another
```
struct JSONTransform {
    static func transform() {
        let fileSystemPersistence = FileSystemPersistance()
        let questions =  fileSystemPersistence.readFile(
            type: Questions.self,
            forResourse: "quiz_data",
            ofType: "json")
        let modify = questions?.questions.map { item -> ModifiedContent in
            let correct = item.correctAnswer
            var choices = [Choices]()
            for index in 0..<item.choices.count {
                if index == correct {
                    choices.append(Choices(correct: true, text: item.choices[index]))
                } else {
                    choices.append(Choices(text: item.choices[index]))
                }
            }
            return ModifiedContent(question: item.question, choices: choices)
        }
        if let modify = modify {
            let modified = Modified(questions: modify)
            fileSystemPersistence.writeToFile(fileName: "questions.json", data: modified)
        }
    }
}
```
All the best,

Oleksii
