import { LLamaChatClient, ChatMessage } from './clients/LLamaChatClient';

export class Application {
  private llamaClient: LLamaChatClient;

  constructor(llamaClient: LLamaChatClient) {
    this.llamaClient = llamaClient;
  }

  public async start(): Promise<void> {
    console.log('Application started successfully!');

    const chatHistory: ChatMessage[] = [
      { role: 'user', content: 'What is the best way to structure a modern TypeScript project?' },
    ];

    try {
      const response = await this.llamaClient.getChatCompletion(chatHistory);
      console.log('LLAMA RESPONSE:', response);
    } catch (error) {
      console.error('Failed to run chat completion:', error);
    }
  }
}
