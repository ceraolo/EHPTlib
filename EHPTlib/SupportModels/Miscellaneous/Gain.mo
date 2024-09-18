within EHPTlib.SupportModels.Miscellaneous;
block Gain
  extends Modelica.Blocks.Math.Gain(k(unit = ""));
  annotation (
    Documentation(info = "<html><head></head><body>This model extends from MSL's gain, to allow using gain values with dimension: in fact, questionably, MSL uses unit=\"1\" for its gain parameter k.</body></html>"));
end Gain;
