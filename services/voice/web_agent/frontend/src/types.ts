// WebSocket message types

export type ClientMessage = 
  | { type: "audio_chunk"; chunkId: string; data: string }
  | { type: "control"; action: "set_language"; language: "zh" | "en" | null };

export type ServerMessage =
  | { type: "info"; message: string }
  | { type: "error"; message: string }
  | { type: "speech_started"; message: string }
  | { type: "asr_start"; message: string }
  | { type: "asr_complete"; text: string }
  | { type: "glm_start"; message: string }
  | { type: "glm_complete"; text: string }
  | { type: "reply_audio_chunk"; data: string; isLast: boolean };
