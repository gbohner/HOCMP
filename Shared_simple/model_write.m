function model = model_write( W, tErr, Bias, Params, Nmaps, isfirst, pos, subs, NSS, KS, PrVar, Nmax )
%SAVE_MODEL Summary of this function goes here
%   Detailed explanation goes here


model.W         = W;
model.tErr      = tErr;
model.Bias      = Bias;
model.Params    = Params;
model.Nmaps     = Nmaps;
model.isfirst   = isfirst;
model.pos       = pos;
model.subs      = subs;
model.NSS       = NSS;
model.KS        = KS;
model.PrVar     = PrVar;
model.Nmax      = Nmax;



end

