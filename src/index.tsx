import React from "react";
import { requireNativeComponent, ViewStyle } from "react-native";

const ComponentName = "StrokeTextView";

type TextAlign = "center" | "left" | "right"

export interface StrokeTextProps {
  text: string;
  fontSize?: number;
  color?: string;
  strokeColor?: string;
  strokeWidth?: number;
  fontFamily?: string;
  style?: ViewStyle;
  align?: TextAlign;
}

const NativeStrokeText = requireNativeComponent<StrokeTextProps>(ComponentName);

export const StrokeText = (props: StrokeTextProps) => {
  return <NativeStrokeText {...props} />;
};
