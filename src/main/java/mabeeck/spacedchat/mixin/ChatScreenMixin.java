package mabeeck.spacedchat.mixin;

import net.minecraft.client.gui.screens.ChatScreen;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

@Mixin(ChatScreen.class)
public class ChatScreenMixin {
    @Inject(at = @At("RETURN"), method = "normalizeChatMessage",cancellable = true)
    private void inject(String chatText, CallbackInfoReturnable<String> cir) {
        cir.setReturnValue(chatText);
    }
}