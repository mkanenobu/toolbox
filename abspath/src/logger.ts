export class Logger {
  public verbose = false;

  constructor(params?: { verbose?: boolean }) {
    if (typeof params?.verbose !== "undefined") {
      this.verbose = params.verbose;
    }
  }

  public debug = (...messages: any[]) => {
    if (this.verbose) {
      const now = new Date().toISOString();
      console.debug(now, ...messages);
    }
  };
}
