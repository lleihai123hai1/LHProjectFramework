function LSCTPerson.prototype:destroy ()

    print("LSCTPerson destroy");

end

function YGLuaViewController.prototype:destroy ()

print("YGLuaViewController destroy");

end

local controller = YGLuaViewController();

controller:testLuaCallBack();

local person = LSCTPerson();
person.name = "vimfung";
person:walk();
person:speak();
