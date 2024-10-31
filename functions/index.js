const functions = require("firebase-functions");
const admin = require("firebase-admin");

const fs = require("fs");
const path = require("path");

// Initialize Firebase Admin SDK
admin.initializeApp();

const db = admin.firestore();

const PROMPTS_FILE_PATH = path.join(__dirname, "prompts.txt");

function getRandomPromptContent() {
  try {
    const data = fs.readFileSync(PROMPTS_FILE_PATH, "utf8");
    const prompts = data.split("\n").filter((line) => line.trim() !== ""); // Ignore empty lines

    const randomIndex = Math.floor(Math.random() * prompts.length);
    return prompts[randomIndex];
  } catch (error) {
    console.error("Error reading prompts file:", error);
    return null;
  }
}

exports.scheduledPostUpload = functions.pubsub
    .schedule("every 24 hours")
    .onRun(async (context) => {
      try {
        const content = getRandomPromptContent();
      	if (!content) {
          return null;
        }

        const newPrompt = {
          text: content,
        };

        // Add a new document to the "posts" collection
        const docRef = await db.collection("prompts").add(newPrompt);

        console.log(`New prompt added with ID: ${docRef.id}`);
      } catch (error) {
        console.error("Error adding new prompt: ", error);
      }

      return null;
    });

