import { Application } from './Application';
import { LLamaChatClient } from './clients/LLamaChatClient';

async function main() {
  try {
    const client = new LLamaChatClient();
    const app = new Application(client);
    await app.start();
  } catch (error) {
    console.error('Startup failed:', error);
  }
}

main();
