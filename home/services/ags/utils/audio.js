import { Audio, Icons } from "../imports.js";

export const audioIcon = () => {
  if (Audio.speaker?.stream.isMuted) return Icons.volume.muted;

  const vol = Audio.speaker?.volume * 100;
  const icon = [
    [101, "overamplified"],
    [67, "high"],
    [34, "medium"],
    [1, "low"],
    [0, "muted"],
  ].find(([threshold]) => threshold <= vol)[1];

  return Icons.volume[icon];
};

export const micIcon = () => {
  if (Audio.microphone?.stream.isMuted) return Icons.microphone.muted;

  const vol = Audio.microphone?.volume * 100;
  const icon = [
    [67, "high"],
    [34, "medium"],
    [1, "low"],
    [0, "muted"],
  ].find(([threshold]) => threshold <= vol)[1];

  return Icons.microphone[icon];
};
