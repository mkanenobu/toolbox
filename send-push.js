#!/usr/bin/env -S node

const toFormData = (obj) => {
  const formData = new FormData();
  Object.entries(obj).forEach(([key, value]) => {
    if (typeof value === "string") {
      formData.append(key, value);
    }
  })
  return formData;
}

const isUrl = (str) => {
  try {
    new URL(str);
    return true;
  } catch (_error) {
    return false;
  }
}

/**
 * pushover でメッセージを送信する
 */
const main = async (args) => {
  const applicationToken = process.env.PUSHOVER_APPLICATION_TOKEN;
  const userKey = process.env.PUSHOVER_USER_KEY;

  if (!applicationToken || !userKey) {
    console.error("PUSHOVER_APPLICATION_TOKEN and PUSHOVER_USER_KEY are required");
    return;
  }

  const message = args[2]?.trim();

  if (!message) {
    console.error("message is required");
    return;
  }

  const url = new URL("https://api.pushover.net/1/messages.json");
  const formData = toFormData({
    token: applicationToken,
    user: userKey,
    message,
    url: isUrl(message) ? message : undefined,
  });

  const result = await fetch(url, {
    method: "POST",
    body: formData,
  });

  console.log(result.statusText);
}

main(process.argv);
