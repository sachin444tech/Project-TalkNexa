class AiService {
  async generateResponse({
    message,
    scenario,
    difficulty,
    userLevel,
  }) {
    // Temporary fallback response.
    //
    // The real AI provider will be connected
    // here in the next stage.

    return {
      response:
        "That's interesting! Could you tell me more about that?",
      scenario,
      difficulty,
      userLevel,
    };
  }
}

module.exports = new AiService();