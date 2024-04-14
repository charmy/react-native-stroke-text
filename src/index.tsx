import React from "react";
import { requireNativeComponent, ViewStyle } from "react-native";

const ComponentName = "StrokeTextView";

export interface StrokeTextProps {
  text: string;
  fontSize?: number;
  color?: string;
  strokeColor?: string;
  strokeWidth?: number;
  fontFamily?: string;
  style?: ViewStyle;
}

const NativeStrokeText = requireNativeComponent<StrokeTextProps>(ComponentName);

export const StrokeText = (props: StrokeTextProps) => {
  return <NativeStrokeText {...props} />;
};
