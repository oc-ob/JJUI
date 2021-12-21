local partsWithId = {}
local awaitRef = {}

local root = {
	ID = 0;
	Type = "TextButton";
	Properties = {
		AnchorPoint = Vector2.new(0.5,0.5);
		BackgroundColor3 = Color3.new(6/17,6/17,6/17);
		Name = "DragBar";
		Position = UDim2.new(0.5,0,0.60833334922791,0);
		Size = UDim2.new(0.60000002384186,0,0.059999998658895,0);
		Text = "";
		BorderSizePixel = 0;
		AutoButtonColor = false;
	};
	Children = {
		{
			ID = 1;
			Type = "TextButton";
			Properties = {
				AnchorPoint = Vector2.new(0.5,0.5);
				Name = "btn";
				Position = UDim2.new(0,0,0.5,0);
				Size = UDim2.new(0.050000000745058,0,1.75,0);
				Text = "";
				BorderSizePixel = 0;
				BackgroundColor3 = Color3.new(10/51,10/51,10/51);
			};
			Children = {};
		};
	};
};

local function Scan(item, parent)
	local obj = Instance.new(item.Type)
	if (item.ID) then
		local awaiting = awaitRef[item.ID]
		if (awaiting) then
			awaiting[1][awaiting[2]] = obj
			awaitRef[item.ID] = nil
		else
			partsWithId[item.ID] = obj
		end
	end
	for p,v in pairs(item.Properties) do
		if (type(v) == "string") then
			local id = tonumber(v:match("^_R:(%w+)_$"))
			if (id) then
				if (partsWithId[id]) then
					v = partsWithId[id]
				else
					awaitRef[id] = {obj, p}
					v = nil
				end
			end
		end
		obj[p] = v
	end
	for _,c in pairs(item.Children) do
		Scan(c, obj)
	end
	obj.Parent = parent
	return obj
end

return function(p) return Scan(root, p) end