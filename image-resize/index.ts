import { main } from "./src/main";

try {
  await main();
} catch (error) {
  console.error(error);
  process.exit(1);
}
