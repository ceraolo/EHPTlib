within EHPTlib.MapBased;

model IceT
  extends Partial.PartialIceTNm;
  Modelica.Blocks.Nonlinear.Limiter limiter(uMin = 0, uMax = 1e99) annotation(
    Placement(transformation(origin = {-80, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput tauRef "torque request (positive when motor)" annotation(
    Placement(transformation(extent = {{-20, -20}, {20, 20}}, rotation = 90, origin = {-60, -122}), iconTransformation(extent = {{-20, -20}, {20, 20}}, rotation = 90, origin = {-60, -118})));
  Modelica.Blocks.Sources.BooleanConstant onSignal annotation(
    Placement(transformation(extent = {{-50, -60}, {-34, -44}})));
equation
  connect(limiter.u, tauRef) annotation(
    Line(points = {{-80, -68}, {-80, -96}, {-60, -96}, {-60, -122}}, color = {0, 0, 127}));
  connect(onSignal.y, switch1.u2) annotation(
    Line(points = {{-33.2, -52}, {-18, -52}, {-18, -52}, {-4, -52}}, color = {255, 0, 255}));
  connect(limiter.y, min1.u2) annotation(
    Line(points = {{-80, -45}, {-80, 0}, {-50, 0}, {-50, 72}, {-34, 72}}, color = {0, 0, 127}));
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = false), graphics = {Text(extent = {{-88, -58}, {-34, -90}}, textString = "Nm")}),
    Diagram(coordinateSystem(preserveAspectRatio = false)),
    Documentation(info = "<html><head></head><body><p>This model extends PartialIceTNm, and just adds an input torque which is the reference ICE is required to follow.</p>
</body></html>"));
end IceT;
