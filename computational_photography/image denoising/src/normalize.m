
function N = normalize(img)
    img = cast(img,'double');
    max_v = max( reshape(img,[],1));
    min_v = min(reshape(img,[],1));
    scale = max_v - min_v;
    N = (img - min_v ) ./ scale;
end