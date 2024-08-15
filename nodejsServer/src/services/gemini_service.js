const { GoogleGenerativeAI } = require("@google/generative-ai");
const dotenv = require("dotenv");
dotenv.config();
 
const gemini_api_key = process.env.GEMINI_API_KEY;
const googleAI = new GoogleGenerativeAI(gemini_api_key);
const geminiConfig = {
  temperature: 0.9,
  topP: 1,
  topK: 1,
  maxOutputTokens: 4096,
};
 
const geminiModel = googleAI.getGenerativeModel({
  model: "gemini-1.5-flash",
  geminiConfig,
});


class GeminiService{
  async sendPromptToServer({image}){
    try {
      const prompt = `I will provide you an image which will contain the todos i have written 
                          you have to respond with the following json in the response. Extract the taskName, date and time from the picture and respond with only the following json format.
                           If you dont find the time take the 9 am time in the format i have specified. 
                          similarly if you dont find the date, take the current date in the format specified.
                          You can also look for words like tommorrow and 3 days from now, morning, evening.
                          Take their dates with respect to current date and time with respect to words like for morning its 9 am , for noon its 12:00pm and for evening its 6:00pm and
                          for night its 9:00pm and for midnight its 12:00am.
                          when you give me the time in the format i have specified, consider 24 hour clock format when giving me the time.
                          If there are multiple todos, separate the objects with commas. NOTE: dont put anything else in the response 
                          Remember to find time and date from each todo and put that in their respective location
                          The following is the format
                          {"todos":[{"taskName":"the_name_you_will_extract","date":"dd-mm-yyyy","time":"hh:mm:ss","completed":false}]}`;
      const imageToSend = {
        inlineData: {
          data: image.data.toString('base64'),
          mimeType: "image/png",
        },
      };
                        
      const result = await geminiModel.generateContent([prompt, imageToSend]);
      const response = result.response;
      console.log(response.text());
      const toStore = JSON.parse(response.text());
      return toStore;
    } catch (error) {
      throw error;
    }
  }
}

module.exports = GeminiService;