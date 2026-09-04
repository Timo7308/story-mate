# 📖 Story Mate – AI-Powered Social Chat App

**Story Mate** is a mobile social chat application that combines **real-time communication, interactive storytelling, and generative AI**.

The core idea is to make conversations between new people less awkward by placing both users inside a shared fictional scenario. Instead of starting with an empty chat, users participate in a narrative, receive roles, and interact within the context of the selected story.

Using the **OpenAI API**, Story Mate can transform user messages so that they stylistically match the current narrative while preserving the original intent of the message.

---

## 📌 Project Overview

Starting a conversation with someone new can often feel uncomfortable or forced.

Story Mate explores a different approach: rather than asking users to immediately find something to talk about, the application provides a **shared narrative context** that acts as an icebreaker.

Users choose a storyline and are assigned roles within that scenario. Their conversation then becomes part of the story.

For example, instead of simply writing:

> Where are you from?

the application can transform the message into a version that better fits the selected narrative while maintaining its meaning.

The goal is to combine **social interaction and storytelling** with AI-assisted communication.

---

## ✨ Core Features

* Real-time chat between users
* Interactive story-based conversations
* Selection of different story scenarios
* Role assignment within a narrative
* AI-assisted message transformation
* User authentication
* Cloud-based backend
* Mobile-first Flutter application

---

## 🤖 AI-Assisted Messaging

One of the central features of Story Mate is the integration of the **OpenAI API**.

Users write their message normally, while the AI can adapt its wording to the current story context.

The transformation is intended to preserve the meaning of the original message while changing its tone and style to match the narrative.

```text
User Message
     │
     ▼
Story Context + Assigned Role
     │
     ▼
OpenAI API
     │
     ▼
Narrative-Styled Message
     │
     ▼
Chat Partner
```

This allows conversations to remain natural while creating a more immersive storytelling experience.

---

## 📖 Story-Based Interaction

When starting a conversation, users select one of the available storylines.

Both participants:

1. Enter the same narrative
2. Receive a role within the story
3. Communicate through the chat
4. Progress through the scenario together

The shared narrative provides an immediate conversational context and reduces the need for traditional small talk.

---

## 🛠️ Tech Stack

### Mobile Development

* Flutter
* Dart

### Backend

* Firebase
* Firebase Authentication
* Cloud-based user and application data

### Artificial Intelligence

* OpenAI API
* Generative AI
* Prompt-based text transformation
* Context-aware message rewriting

### Development

* Android Studio
* Git
* GitHub

---

## 🏗️ Architecture

The application combines a Flutter frontend with Firebase services and the OpenAI API.

```text
┌─────────────────────────┐
│      Flutter App        │
│                         │
│   Chat Interface        │
│   Story Selection       │
│   User Interaction      │
└────────────┬────────────┘
             │
      ┌──────┴───────┐
      │              │
      ▼              ▼
┌─────────────┐  ┌──────────────┐
│  Firebase   │  │  OpenAI API  │
│             │  │              │
│ Auth        │  │ Message      │
│ User Data   │  │ Transformation│
│ App Data    │  │ Story Context │
└─────────────┘  └──────────────┘
```

Firebase handles authentication and backend data, while the OpenAI API provides the generative AI functionality used to adapt messages to the selected narrative.

---

## 🎯 Project Goals

Story Mate was designed to explore how generative AI can be integrated into social applications beyond traditional chatbot use cases.

The project focuses on:

* reducing barriers when meeting new people online
* using storytelling as a conversational icebreaker
* integrating generative AI into human-to-human communication
* experimenting with context-aware text transformation
* combining mobile development with cloud services and AI APIs

The AI is not intended to replace either participant. Instead, it acts as a **supporting layer between two human users**, modifying how messages are expressed within the fictional setting.

---

## 🚧 Current Status

Story Mate is currently a **prototype and portfolio project**.

The application is not production-ready at the moment because parts of the original infrastructure require updates, including:

* OpenAI API integration
* Firebase backend configuration
* authentication and service configuration

The existing codebase demonstrates the application's architecture, UI, interaction concept, and AI integration approach.

---

## 🔮 Future Improvements

Possible future development includes:

* updating the OpenAI API integration
* migrating and updating Firebase services
* improved authentication
* additional story scenarios
* dynamic story progression
* improved prompt engineering
* more sophisticated context management
* message history awareness
* improved UI and UX
* deployment as a fully functional Android application
* potential iOS support

---

## 💡 Concept

Most AI chat applications focus on conversations **between a human and an AI assistant**.

Story Mate explores a different interaction model:

```text
Human  ←→  AI-supported narrative layer  ←→  Human
```

The AI does not become the conversation partner. Instead, it enriches communication between two people by embedding their messages into a shared fictional world.

---

## 📜 Project Context

Story Mate was developed as an experimental mobile application combining:

* Mobile App Development
* Generative AI
* API Integration
* Firebase
* Real-Time Communication
* Interactive Storytelling
* Human-Computer Interaction

It serves as a prototype for exploring how generative AI can support and reshape social interaction in mobile applications.

---

## 📜 License

This repository is provided for **educational, experimental, and portfolio purposes**.
