const express = require("express");

const aiService = require("../services/ai.service");

const router = express.Router();

router.post("/conversation", async (req, res) => {
  try {
    const {
      message,
      scenario,
      difficulty,
      userLevel,
    } = req.body;

    if (!message || !message.trim()) {
      return res.status(400).json({
        success: false,
        message: "User message is required.",
      });
    }

    const result =
      await aiService.generateResponse({
        message,
        scenario:
          scenario || "General Conversation",
        difficulty:
          difficulty || "Intermediate",
        userLevel:
          userLevel || "Intermediate",
      });

    return res.json({
      success: true,
      data: result,
    });
  } catch (error) {
    console.error(
      "AI conversation error:",
      error
    );

    return res.status(500).json({
      success: false,
      message:
        "Unable to process the AI conversation.",
    });
  }
});

module.exports = router;