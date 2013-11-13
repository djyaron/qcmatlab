function res = readIndo(filename)

fid1 = fopen([filename,'.ido']);
if (fid1 == -1)
   error(['in readIndo, could not find file: ',filename]);
end
res.norb = fread(fid1,1,'integer*4');
res.aorbAtom = fread(fid1,[1,res.norb],'integer*4');
res.aorbAtom = res.aorbAtom +1; % C++ starts count at 0 instead of 1
res.aorbType = fread(fid1,[1,res.norb],'integer*4');

ntest = fread(fid1,1,'integer*4');
if (ntest ~= res.norb)
   error('atomic and fock basis sizes differ');
end
res.nfilled = fread(fid1,1,'integer*4');
res.hfE  = fread(fid1,1,'real*8');
res.orbE = fread(fid1,[1,res.norb],'real*8');
res.orb = fread(fid1,[res.norb,res.norb],'real*8');

res.nsci = fread(fid1,1,'integer*4');
res.nscibasis = fread(fid1,1,'integer*4');
res.esci = fread(fid1,[1,res.nsci],'real*8');
ntest = fread(fid1,[1,2],'integer*4');
res.r = zeros(res.nsci,res.nsci,3);
res.r(:,:,1) = fread(fid1,[res.nsci,res.nsci],'real*8');
ntest = fread(fid1,[1,2],'integer*4');
res.r(:,:,2) = fread(fid1,[res.nsci,res.nsci],'real*8');
ntest = fread(fid1,[1,2],'integer*4');
res.r(:,:,3) = fread(fid1,[res.nsci,res.nsci],'real*8');
temp = fread(fid1,[2,res.nscibasis],'integer*4');
res.ehsci = temp' +1; % +1 fixes the counting from 0 issue
res.wfsci = fread(fid1,[res.nscibasis,res.nsci],'real*8');

for i = 1:res.nsci
    res.osc(1,i) = (res.esci(1,i)-res.esci(1,1))*(res.r(1,i,1)^2+res.r(1,i,2)^2+res.r(1,i,3)^2);
end