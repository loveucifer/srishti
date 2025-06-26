// This is a stub for the IFrameElement to allow the code to compile on non-web platforms.
// It will throw an error if accessed, which is fine because our code path 
// is protected by a 'kIsWeb' check, meaning this code is never actually executed on mobile.

class IFrameElement {
  // A getter for the 'style' property that throws an error.
  dynamic get style => throw UnimplementedError('HTML is not available on this platform.');
  
  // A setter for the 'srcdoc' property that throws an error.
  set srcdoc(String? value) => throw UnimplementedError('HTML is not available on this platform.');
}
