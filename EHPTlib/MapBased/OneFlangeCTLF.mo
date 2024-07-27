within EHPTlib.MapBased;
model OneFlangeCTLF "Simple map-based model of an electric drive"
  extends Partial.PartialOneFlangeCTLF(
                                      toElePow(
      A=A,
      bT=bT,
      bW=bW,
      bP=bP,
      tauMax=tauMax,
      powMax=powMax,
      wMax=wMax));
  Modelica.Blocks.Interfaces.RealInput tauRef "(positive when motor peration)" annotation (
    Placement(visible = true, transformation(origin = {-118, -66}, extent = {{-18, -18}, {18, 18}}, rotation = 0), iconTransformation(origin={-100,0},    extent = {{-20, -20}, {20, 20}}, rotation = 0)));
equation
  connect(variableLimiter.u, tauRef) annotation (
    Line(points = {{-2, 30}, {14, 30}, {14, -66}, {-118, -66}}, color = {0, 0, 127}));
  annotation (
    Documentation(info="<html>
<p>Model similar to OneFlangeCTCT, but with internal losses computed through a loss formula instead of an efficiency map (thus the last part of the name &quot;LF&quot; instead of &quot;CT&quot;).</p>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-80},{100,80}},        preserveAspectRatio = false, initialScale = 0.1)),
    Icon(coordinateSystem(extent = {{-100, -80}, {100, 100}}, preserveAspectRatio = false, initialScale = 0.1)));
end OneFlangeCTLF;
