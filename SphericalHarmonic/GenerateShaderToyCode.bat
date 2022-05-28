cd SphericalHarmonic
copy /y /b Visualizer.glsl ..\Generated\SphericalHarmonicVisualizer.glsl
copy /y /b EnvmapCommon.glsl+EnvmapBackground.glsl ..\Generated\SphericalHarmonicEnvironmentMap_BufferB.glsl
copy /y /b EnvmapEncodeSH.glsl ..\Generated\SphericalHarmonicEnvironmentMap_BufferC.glsl
copy /y /b EnvmapGroundTruth.glsl ..\Generated\SphericalHarmonicEnvironmentMap_CubaA.glsl
copy /y /b EnvmapCommon.glsl+Envmap.glsl ..\Generated\SphericalHarmonicEnvironmentMap_Image.glsl
cd ..