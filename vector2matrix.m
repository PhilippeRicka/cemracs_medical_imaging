function M = vector2matrix(v,L)

M = zeros(size(L));

for i = 1:size(L,2)
    M(:,i) = v(L(:,i));
end