import axios, { AxiosInstance, AxiosResponse } from 'axios';

// Define interfaces for clarity and type safety
export interface ChatMessage {
  role: 'user' | 'assistant' | 'system';
  content: string;
}

export interface ChatCompletionResponse {
  id: string;
  object: string;
  choices: {
    message: {
      role: string;
      content: string;
    };
    finish_reason: string;
  }[];
}

/**
 * Client for interfacing with the LLAMA.CPP Chat Completion service.
 * @param baseUrl The base URL of the LLAMA.CPP service.
 */
export class LLamaChatClient {
  private axiosInstance: AxiosInstance;

  constructor(baseUrl: string = 'http://localhost:8080/v1/chat/completions') {
    this.axiosInstance = axios.create({
      baseURL: baseUrl,
      headers: {
        'Content-Type': 'application/json',
      },
    });
  }

  /**
   * Sends a list of essages to the LLAMA.CPP service and returns the response content.
   * @param messages The conversation history.
   * @returns A promise that resolves with the model's response content.
   * @throws Error if the API call fails.
   */
  public async getChatCompletion(messages: Array<ChatMessage>): Promise<string> {
    try {
      const response: AxiosResponse<ChatCompletionResponse> = await this.axiosInstance.post(
        '', // The endpoint path is already in the baseURL
        {
          model: 'llama-cpp', // Assuming a default model name
          messages: messages,
          temperature: 0.7, // Default temperature
          max_tokens: 2048, // Default max tokens
          stream: false, // Interactive boolean for chatbot mode
          stream_options: {
            include_usage: false, // This is the critical line
          },
        },
      );

      if (response.data.choices && response.data.choices.length > 0) {
        return response.data.choices[0].message.content;
      } else {
        throw new Error('Chat completion response was empty or invalid.');
      }
    } catch (error) {
      console.error('Error communicating with LLAMA.CPP service:', error);
      if (axios.isAxiosError(error) && error.response) {
        throw new Error(
          `API Error: ${error.response.status} - ${error.response.data.error || 'Unknown API Error'}`,
        );
      }
      throw new Error('Failed to connect to the LLAMA.CPP service.');
    }
  }
}
