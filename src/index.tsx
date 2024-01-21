import React from "react";
import { requireNativeComponent } from "react-native";

const ComponentName = "StrokeTextView";

export interface StrokeTextProps {
  text: string;
  fontSize?: number;
  color?: string;
  strokeColor?: string;
  strokeWidth?: number;
  fontFamily?: string;
}

const NativeStrokeText = requireNativeComponent<StrokeTextProps>(ComponentName);

export const StrokeText = (props: StrokeTextProps) => {
  return <NativeStrokeText {...props} key={JSON.stringify(props)} />;
};
