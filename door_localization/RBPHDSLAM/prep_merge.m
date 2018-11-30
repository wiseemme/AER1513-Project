function merge_dict = prep_merge(merge_id, pairs)
%Prepare merge id order
%Initialize variables
dict_length = length(merge_id);
merge_dict = struct;

%Convert merge ids into a lexicon
merge_lex = sortrows([merge_id , pairs(merge_id, :)], [3 2]);

%Initialize the merge_dict with last pair
merge_dict(1).pair = [merge_lex(end, 2); merge_lex(end, 3)];

%Need to think about this more
for i = dict_length - 1: -1: 1
    %Get the values to assist search
    id1 = merge_lex(i, 2);
    id2 = merge_lex(i, 3);
    found = 0;
    num_merges = length(merge_dict);
    merge_group_num = [];
    temp_dict = [id1; id2];
    for j = num_merges: -1 :1
        %Check to see if the landmarks are in any of the merges
        id1_found = ~isempty(find(merge_dict(j).pair == id1, 1));
        id2_found = ~isempty(find(merge_dict(j).pair == id2, 1));
        if  id1_found || id2_found
            merge_group_num(end+1) = j;
            if found == 0
                found = 1;
            end
        end
    end
    if found
        for j = length(merge_group_num):1
            %If found union the entries together
            group_id = merge_group_num(j);
            temp_dict = union(temp_dict, merge_dict(group_id).pair(:));
            if j > 1
                merge_dict(j)= [];
            end
        end
        merge_dict(merge_group_num(1)).pair = temp_dict;
    else
        merge_dict(end + 1).pair = temp_dict;
    end
end
end

