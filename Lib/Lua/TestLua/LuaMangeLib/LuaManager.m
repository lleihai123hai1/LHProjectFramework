//
//  LuaManager.m
//  LuaTest
//
//  Created by Ogan Topkaya on 17/02/14.
//  Copyright (c) 2014 Peak Games. All rights reserved.
//
#import "YGLuaViewController.h"
#import "LuaManager.h"
#import "NSString+Paths.h"

#define to_cString(s) ([s cStringUsingEncoding:[NSString defaultCStringEncoding]])

int l_testOcFunction(lua_State *L){
    YGLuaViewController *vc = (__bridge YGLuaViewController *)lua_touserdata(L, 1);
    [vc performSelector:@selector(testLuaCallBack) withObject:nil];
    return 0;
}


static LuaManager *sManager = nil;

@interface LuaManager ()

@property (nonatomic,unsafe_unretained) lua_State *state;

@end

@implementation LuaManager
#pragma mark 执行脚本文件单独方法
#pragma mark --utilities.lua/calculate
- (NSInteger)calculate:(NSInteger)number{
    [self openFile:@"utilities.lua"];
    lua_State *L = self.state;
    lua_getglobal(L, "calculate");
    lua_pushnumber(L, number);
    if (lua_pcall(L, 1, 1, 0) != LUA_OK) {
        NSLog(@"error in running");
    }
    
    NSInteger result = lua_tonumber(L, -1);
    lua_pop(L, 1);
    return result;
}
#pragma mark --configuration.lua/isAllowedToExecute
- (BOOL)isAllowedToExecute:(NSString *)string{
    [self openFile:@"configuration.lua"];
    lua_State *L = self.state;
    
    lua_getglobal(L, "isAllowedToExecute");
    lua_pushstring(L, to_cString(string));
    if (lua_pcall(L, 1, 1, 0) != LUA_OK) {
        NSLog(@"error in running");
    }
    
    NSInteger result = lua_toboolean(L, -1);
    lua_pop(L, 1);
    
    return result;
}

- (NSInteger)consolePosition{
    [self openFile:@"configuration.lua"];
    lua_State *L = self.state;
    
    lua_getglobal(L, "consoleYPosition");
    NSInteger y = lua_tointeger(L, -1);
    return y;
}

- (void)testRegisterOcFunction:(UIViewController *)vc{
    [self registerFunction:l_testOcFunction withName:@"testOcFunctionCallback"];//注册ios方法
    [[LuaManager defaultManager] callFunctionNamed:@"testOcFunction" withObject:vc];//利用脚本文件执行注册的ios方法
}



#pragma mark --基本类方法
+ (instancetype)defaultManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sManager = [[LuaManager alloc] init];
    });
    return sManager;
}

- (lua_State *)state{
    if (!_state) {
        _state = luaL_newstate();
        luaL_openlibs(_state);
        lua_settop(_state, 0);
    }
    return _state;
}


- (void)runCodeFromString:(NSString *)code{
    lua_State *L = self.state;
    
    int error = luaL_loadstring(L, to_cString(code));
    if (error) {
        luaL_error(L, "error : %s",lua_tostring(L, -1));
        return;
    }
    
    error = lua_pcall(L, 0, 0, 0);
    if (error) {
        luaL_error(L, "run error: %s",lua_tostring(L, -1));
        return;
    }
}
- (void)openFile:(NSString *)file{
    lua_State *L = self.state;
    NSString *path = [NSString getLuaPath:file];
    if (luaL_loadfile(L, to_cString(path)) != LUA_OK || lua_pcall(L, 0, 0, 0) != LUA_OK) {
        luaL_error(L, "cannot compile Lua file: %s", lua_tostring(L, -1));
    }
}

- (void)registerFunction:(lua_CFunction)function withName:(NSString *)name {
    lua_register(self.state, to_cString(name), function);
}

- (void *)performFuntionOnLuaFile:(NSString *)file function:(NSString *)function withObjects:(void *)obj,... NS_REQUIRES_NIL_TERMINATION{
    
    [self openFile:file];
    lua_State *L = self.state;
    lua_getglobal(L, to_cString(function));
    
    
    va_list ap;
    va_start(ap, obj);
    
    int objCount = 0;
    int index = 2;
    while (obj != NULL) {
        lua_pushnumber(L,(int) obj);
        obj = va_arg(ap, void *);
        objCount++;
        index++;
    }
    va_end(ap);
    
    if (lua_pcall(L, objCount, 1, 0)){
        NSLog(@"error");
    }
    
    int result = lua_tonumber(L, -1);
    lua_pop(L, 1);
    
    return (void *)result;
}

- (void)callFunctionNamed:(NSString *)name withObject:(NSObject *)object {
    // get state
    [self openFile:@"configuration.lua"];
    lua_State *L = self.state;
    
    // prepare for "function(object)"
    lua_getglobal(L, to_cString(name));
    lua_pushlightuserdata(L, (__bridge void *)(object));
    
    // run
    int error = lua_pcall(L, 1, 0, 0);
    if (error) {
        luaL_error(L, "cannot run Lua code: %s", lua_tostring(L, -1));
        return;
    }
}

@end
