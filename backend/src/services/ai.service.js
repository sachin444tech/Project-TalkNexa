const { GoogleGenAI } = require("@google/genai");

const aiConfig = require("../config/ai.config");

class AiService {
  constructor() {
    if (!process.env.AI_API_KEY) {
      throw new Error("AI_API_KEY is not configured.");
    }

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

        return `${role}: ${item.content}`;
      })
      .join("\n");

    const prompt = `
You are TalkNexa, an AI English speaking partner.

Your job is to help English learners practice speaking naturally.

Practice scenario:
${scenario}

Difficulty:
${difficulty}

User English level:
${userLevel}

Important behavior:
- Speak naturally and conversationally.
- Keep your response appropriate for the user's English level.
- Encourage the learner to continue speaking.
- Do not give long explanations unless necessary.
- If the user's English has a clear mistake, gently correct it.
- Prefer conversation over teaching a long grammar lesson.
- Stay within the selected scenario.
- Never pretend to be a human.
- Be friendly, supportive, and patient.

Previous conversation:
${historyText || "No previous conversation."}

Current user message:
${message}

Respond as the TalkNexa AI speaking partner.
`;
//console time and timeEnd is use to check how much ai taking time to response.
    console.time("Gemini AI response");

    const response =
      await this.ai.models.generateContent({
        model: aiConfig.model,
        contents: prompt,
      });

      console.timeEnd("Gemini AI response");

    return {
      response: response.text,
      scenario,
      difficulty,
      userLevel,
    };
  }
}

module.exports = new AiService();