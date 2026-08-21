const { GoogleGenAI } = require("@google/genai");

class AiService {
  constructor() {
    this.ai = new GoogleGenAI({
      apiKey: process.env.AI_API_KEY,
    });
  }

  async generateResponse({
    message,
    scenario,
    difficulty,
    userLevel,
    conversationHistory = [],
  }) {
    const historyText = conversationHistory
      .map((item) => {
        const role =
          item.role === "assistant"
            ? "TalkNexa AI"
            : "User";

        return `${role}: ${item.text}`;
      })
      .join("\n");

    const prompt = `
You are TalkNexa, an AI English speaking partner.

Your purpose is to help the user practice spoken English naturally.

Practice information:
- Scenario: ${scenario}
- Difficulty: ${difficulty}
- User English level: ${userLevel}

Conversation so far:
${historyText || "No previous conversation."}

Current user message:
User: ${message}

Your job has two parts:

PART 1 — CONVERSATION
Create a natural, friendly response that continues the conversation.

PART 2 — ENGLISH FEEDBACK
Analyze the user's current message for meaningful English mistakes.

Feedback rules:
- Do not correct every minor mistake.
- Only provide feedback when it is genuinely useful.
- Keep corrections appropriate for the user's English level.
- Never criticize, shame, or embarrass the user.
- Keep the explanation short and simple.
- If there is no meaningful mistake, set hasCorrection to false.
- The conversation response must remain natural and encouraging.

IMPORTANT:
Return ONLY valid JSON.
Do not use markdown.
Do not use code fences.
Do not add any text before or after the JSON.

Use exactly this structure:

{
  "response": "Your natural conversational response",
  "feedback": {
    "hasCorrection": true,
    "original": "The user's original sentence",
    "corrected": "The corrected sentence",
    "explanation": "A short and simple explanation"
  }
}

If there is no meaningful correction, use:

{
  "response": "Your natural conversational response",
  "feedback": {
    "hasCorrection": false,
    "original": "",
    "corrected": "",
    "explanation": ""
  }
}
`;

    const response =
      await this.ai.models.generateContent({
        model: "gemini-3.5-flash-lite",
        contents: prompt,
      });

    const text = response.text;

    if (!text || !text.trim()) {
      throw new Error(
        "Gemini returned an empty response."
      );
    }

    let parsedResponse;

    try {
      parsedResponse = JSON.parse(text.trim());
    } catch (error) {
      console.error(
        "Gemini returned invalid JSON:",
        text
      );

      throw new Error(
        "Gemini returned an invalid response format."
      );
    }

    if (
      !parsedResponse.response ||
      typeof parsedResponse.response !== "string"
    ) {
      throw new Error(
        "Gemini response is missing the conversation response."
      );
    }

    const feedback =
      parsedResponse.feedback || {};

    return {
      response: parsedResponse.response.trim(),
      feedback: {
        hasCorrection:
          feedback.hasCorrection === true,
        original:
          typeof feedback.original === "string"
            ? feedback.original.trim()
            : "",
        corrected:
          typeof feedback.corrected === "string"
            ? feedback.corrected.trim()
            : "",
        explanation:
          typeof feedback.explanation === "string"
            ? feedback.explanation.trim()
            : "",
      },
      scenario,
      difficulty,
      userLevel,
    };
  }
}

module.exports = new AiService();